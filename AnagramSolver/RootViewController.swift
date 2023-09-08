//
//  RootViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 23/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUtils
import MessageUI
import SwiftUI

class RootViewController: UIViewController, AppStateChangeObserver, MFMailComposeViewControllerDelegate
{
    private var model : Model!
    private let searchSegueId = "searchSegue"
    lazy private(set) var monospacedFont : UIFont? = {
        if let font = UIFont(name: "Menlo-Regular",size: 24.0) {
            //Accessibility - Text Size:
            //Dynamic font types require size to be specified as .title1 instead of fixed point size
            return UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
        }
        return nil
    }()
    private let systemFont = UIFont.preferredFont(forTextStyle: .title1)
    private var coordinator = Coordinator.sharedInstance
    private let queryTextFieldDelegate = QueryTextFieldDelegate()

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var textFieldQuery: UITextField!
    
    @IBAction func queryFinished(_ sender: UITextField) {
        if shouldPerformSegue(withIdentifier: searchSegueId, sender: self)
        {
            performSegue(withIdentifier: searchSegueId, sender: self)
        }
    }

    @IBAction func settingsClicked(_ sender: Any) {
        coordinator.show(coordinator.SHOW_SETTINGS)
    }
    
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        coordinator.rootVC = self
        coordinator.showCards = Model.sharedInstance.settings.showCardTips
        return UIHostingController(coder: coder, rootView: RootView(coordinator: coordinator))
    }
    
    func sendFeedback(){
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject(Strings.feedbackSubject)
            mailVC.setToRecipients([Strings.emailAddress])
            mailVC.setMessageBody("", isHTML: false)
            present(mailVC, animated: true, completion: nil)
        } else if let emailUrl = mpdbCreateEmailUrl(to: Strings.emailAddress, subject: Strings.feedbackSubject, body: "")  {
            UIApplication.shared.open(emailUrl)
        } else {
            self.mpdbShowErrorAlert("Email Not Supported", msg: "Please email me at: \(Strings.emailAddress)")
        }
    }

    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        //dismiss on send
        dismiss(animated: true, completion: nil)
    }

    func showMe(query : String){
        textFieldQuery.text = model.settings.useUpperCase ? query.uppercased() : query
        if shouldPerformSegue(withIdentifier: searchSegueId, sender: self)
        {
            performSegue(withIdentifier: searchSegueId, sender: self)
        }
    }

    @IBAction func backgroundTap(_ sender: UIControl) {
        //close the keyboard
        textFieldQuery.resignFirstResponder();
    }

    func updateSettings(){
        let settings = Model.sharedInstance.settings
        let font = settings.useMonospacedFont ? monospacedFont : systemFont
        if font?.fontName != textFieldQuery.font?.fontName {
            //font setting has changed
            textFieldQuery.font = font
        }
        switch settings.keyboardType {
        case Settings.keyboardWebSearch:
            textFieldQuery.keyboardType = .webSearch
        default:
            textFieldQuery.keyboardType = .emailAddress
        }
        textFieldQuery.autocapitalizationType = settings.useUpperCase ? .allCharacters : .none
        queryTextFieldDelegate.convertFullStopToQuestionMark = settings.fullStopToQuestionMark
        queryTextFieldDelegate.convertSpaceToQuestionMark = settings.spaceToQuestionMark
    }
    
    func applyDarkModeSetting(){
        let window = UIApplication.shared.connectedScenes
            .compactMap{$0 as? UIWindowScene}
            .flatMap {$0.windows}
            .first
        let darkMode = Model.sharedInstance.settings.darkModeOverride
        //Map dark mode setting to UIUserInterfaceStyle
        switch (darkMode){
        case Settings.darkModeValueLight:
            window?.overrideUserInterfaceStyle = .light
        case Settings.darkModeValueDark:
            window?.overrideUserInterfaceStyle = .dark
        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateSettings()
        applyDarkModeSetting()
        model = Model.sharedInstance
        model.appState.addObserver(observer: self)
        //ATT prompt can only be shown when the app becomes active, so need to listen for this event.
        NotificationCenter.default.addObserver(self, selector: #selector (appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        //prevent email autocomplete showing on the keyboard
        textFieldQuery.textContentType = UITextContentType(rawValue: "")
        textFieldQuery.delegate = queryTextFieldDelegate
    }

    ///Called when the app becomes active
    ///ATT Dialog will only be shown when the app is active
    ///requestTrackingAuthorization will return status undetermined if called before app is active
    ///and any app update will be rejected by Apple
    @objc private func appDidBecomeActive(){
        model.setUpAds()
        //Now ads are set up no need to receive any more updates
        NotificationCenter.default.removeObserver(self,name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        modelToView(model.appState.appState)
        if (model.settings.showKeyboard){
            textFieldQuery.becomeFirstResponder()
        }
    }
    
    /*
    Recommended way to initialize child view controllers
    is here in prepareForSegue
    http://stackoverflow.com/questions/13279105/access-container-view-controller-from-parent-ios
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == searchSegueId
        {
            model.prepareToSearch()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if searchSegueId == identifier
        {
            if !model.appState.isReadyFinished()
            {
                mpdbShowErrorAlert("Loading...", msg: "Please wait, loading the wordlist")
                return false
            }
            if let query = textFieldQuery.text, model.setAndValidateQuery(query)
            {
                return true
            }
            else
            {
                mpdbShowErrorAlert("Search Error", msg: "Please enter letters a to z")
                return false
            }
        }
        
        return true
    }
    
    func appStateChanged(_ newState: AppStates)
    {
        //update UI on main thread
        DispatchQueue.main.async
        {
            self.modelToView(newState)
        }
    }
    
    fileprivate func modelToView(_ state : AppStates)
    {
        switch state
        {
        case .uninitialized:
            self.searchButton.isEnabled=false
            let proFlag = self.model.settings.isProMode
            self.title = proFlag ? "AS Pro" : "Anagram Solver"
            //load dictionary on a worker thread
            DispatchQueue.global(qos: .default).async
            {
                self.model.loadDictionary()
            }
        case .loading:
            self.searchButton.isEnabled=false
        case .ready:
            self.searchButton.isEnabled=true
        case .searching:
            self.searchButton.isEnabled=false
        case .finished:
            self.searchButton.isEnabled=true
        case .error:
            mpdbShowAlert(Strings.errorTitle, msg: Strings.errorMessage)
        }
    }
}
