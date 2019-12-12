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

class RootViewController: UIViewController, AppStateChangeObserver, MFMailComposeViewControllerDelegate, UICollectionViewDelegateFlowLayout
{
    fileprivate var model : Model!

    let searchSegueId = "searchSegue"
    let aboutSegueId = "aboutSegue"
    let helpSegueId = "helpSegue"
    let userGuideSegueId = "segueUserGuide"
    let tipsDataSource = TipsDataSource()
    
    let monospacedFont = UIFont(name: "Menlo-Regular",size: 24.0)
    let systemFont = UIFont.systemFont(ofSize: 24.0, weight: .regular)

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var textFieldQuery: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func queryFinished(_ sender: UITextField) {
        if shouldPerformSegue(withIdentifier: searchSegueId, sender: self)
        {
            performSegue(withIdentifier: searchSegueId, sender: self)
        }
    }

    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let helpAction = UIAlertAction(title: "User Guide", style: .default, handler: {action in self.showUserGuide()})
        let aboutAction = UIAlertAction(title: "About & Privacy", style: .default, handler: {action in self.showAbout()})
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in self.showSettings()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        controller.addAction(helpAction)
        controller.addAction(aboutAction)
        controller.addAction(settingsAction)
        controller.addAction(cancelAction)
        
        //Anchor popover to button for iPads
        if let ppc = controller.popoverPresentationController{
            ppc.barButtonItem = menuButton
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func rateApp(){
        Model.sharedInstance.ratings.viewOnAppStore()
    }
    
    func sendFeedback(){
        let emailAddress = "pigdogbay@yahoo.co.uk"
        let subject = "Anagram Solver Feedback iOS v1.06"
        let body = "Your feedback is most welcome\n *Report Bugs\n *Suggest new features\n *Ask for help\n\n\nHi Mark,\n\n"
        	
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject(subject)
            mailVC.setToRecipients([emailAddress])
            mailVC.setMessageBody(body, isHTML: false)
            present(mailVC, animated: true, completion: nil)
        } else {
            self.mpdbShowErrorAlert("No Email", msg: "This device is not configured for sending emails.")
        }
    }
    func recommend(){
        let firstActivityItem = "Take a look at Anagram Solver "+Model.getAppWebUrl()
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        //For iPads need to anchor the popover, crashes if not set
        if let ppc = activityViewController.popoverPresentationController {
            ppc.sourceView = self.view
        }
        self.present(activityViewController, animated: true, completion: nil)
    }

    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        //dismiss on send
        dismiss(animated: true, completion: nil)
    }
    
    func showSettings(){
        let application = UIApplication.shared
        let url = URL(string: UIApplication.openSettingsURLString)! as URL
        if application.canOpenURL(url){
            application.open(url,options: [:],completionHandler: nil)
        }
    }
    func showHelp(){
        performSegue(withIdentifier: helpSegueId, sender: self)
    }
    func showAbout(){
        performSegue(withIdentifier: aboutSegueId, sender: self)
    }
    func showUserGuide(){
        performSegue(withIdentifier: userGuideSegueId, sender: self)
    }
    

    
    func showMe(query : String){
        textFieldQuery.text = query
        if shouldPerformSegue(withIdentifier: searchSegueId, sender: self)
        {
            performSegue(withIdentifier: searchSegueId, sender: self)
        }
    }
    

    @IBAction func backgroundTap(_ sender: UIControl) {
        //close the keyboard
        textFieldQuery.resignFirstResponder();
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fontSettingsCheck(){
        let font = Model.sharedInstance.settings.useMonospacedFont ? monospacedFont : systemFont
        if font?.fontName != textFieldQuery.font?.fontName {
            //font setting has changed
            textFieldQuery.font = font
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tipsDataSource.showMeCallback = showMe
        tipsDataSource.settingsCallback = showSettings
        tipsDataSource.viewGuideCallback = showUserGuide
        tipsDataSource.rateCallback = rateApp
        tipsDataSource.feedbackCallback = sendFeedback
        tipsDataSource.recommendCallback = recommend
        self.collectionView.dataSource = tipsDataSource
        self.collectionView.delegate = self
        self.collectionView.contentInset = UIEdgeInsets(top: 16, left: 8, bottom: 20, right: 8)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //remove shadow line from underneath the nav bar
        //https://stackoverflow.com/questions/19226965/how-to-hide-uinavigationbar-1px-bottom-line
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        fontSettingsCheck()
        model = Model.sharedInstance
        model.appState.addObserver(observer: self)
        //Apply any setting changes when coming back from the settings screen
        NotificationCenter.default.addObserver(self, selector: #selector (appEnterForgeround), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        if mpdbCheckIsFirstTime()
        {
            mpdbShowAlert("Welcome",msg: "Thanks for trying Anagram Solver, enter your letters and search over 310,000 words!")
        }
    }
    //Only called when view re-appears from background
    @objc func appEnterForgeround() {
        //check for any settings changes
        model.checkForSettingsChange()
        fontSettingsCheck()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        modelToView(model.appState.appState)
        if (model.settings.showKeyboard){
            textFieldQuery.becomeFirstResponder()
        }
    }
    
    //Recompute layout for the collection view on rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Min width 288 pixels, left and right margin 16 pixels each, for 2 columns 16 pixels between columns
        var width = collectionView.bounds.width
        if width > 623.0 {
            width = (width - 3.0*16.0)/2.0
        } else {
            //single column, make space for the margins
            width = width - 2.0*16.0
        }
        return CGSize(width: width, height: 260.0)
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
        } else if segue.identifier == userGuideSegueId {
            if let definitionVC = segue.destination as? DefinitionViewController {
                definitionVC.word = "User Guide"
                definitionVC.definitionUrl = "https://pigdogbay.blogspot.co.uk/2017/11/anagram-solver-guide.html"
            }
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
        }
    }
}
