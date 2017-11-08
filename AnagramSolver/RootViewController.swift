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

class RootViewController: UIViewController, StateChangeObserver, MFMailComposeViewControllerDelegate
{
    fileprivate var model : Model!

    let searchSegueId = "searchSegue"
    let goProSegueId = "goProSegue"
    let helpSegueId = "helpSegue"
    let tipsDataSource = TipsDataSource()

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
        let rateAction = UIAlertAction(title: "Rate Anagram Solver", style: .default, handler: {action in self.rateApp()})
        let sendFeedbackAction = UIAlertAction(title: "Send Feedback", style: .default, handler: {action in self.sendFeedback()})
        let goProAction = UIAlertAction(title: "Go Pro", style: .default, handler: {action in self.showGoPro()})
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in self.showSettings()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        controller.addAction(rateAction)
        controller.addAction(sendFeedbackAction)
        controller.addAction(goProAction)
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
        if !MFMailComposeViewController.canSendMail()
        {
            self.mpdbShowErrorAlert("No Email", msg: "This device is not configured for sending emails.")
            return
        }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject("Anagram Solver Feedback iOS v1.02")
        mailVC.setToRecipients(["pigdogbay@yahoo.co.uk"])
        mailVC.setMessageBody("Your feedback is most welcome\n *Report Bugs\n *Suggest new features\n *Ask for help\n\n\nHi Mark,\n\n[Enter you message here]", isHTML: false)
        present(mailVC, animated: true, completion: nil)
    }

    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        //dismiss on send
        dismiss(animated: true, completion: nil)
    }
    
    func showSettings(){
        let application = UIApplication.shared
        let url = URL(string: UIApplicationOpenSettingsURLString)! as URL
        if application.canOpenURL(url){
            application.openURL(url)
        }
    }
    func showHelp(){
        performSegue(withIdentifier: helpSegueId, sender: self)
    }
    func showGoPro(){
        performSegue(withIdentifier: goProSegueId, sender: self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector (appEnterForgeround), name: Notification.Name.UIApplicationWillEnterForeground, object: app)
    }
    //Only called when view re-appears from background
    @objc func appEnterForgeround() {
        //check for any settings changes
        model.checkForSettingsChange()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.collectionView.dataSource = tipsDataSource
//        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
//        }
        
        model = Model.sharedInstance
        model.addObserver("root", observer: self)
        if mpdbCheckIsFirstTime()
        {
            mpdbShowAlert("Welcome",msg: "Thanks for trying Anagram Solver, enter your letters and search over 130,000 words!")
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        modelToView(model.state)
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
            if !model.isReady()
            {
                mpdbShowErrorAlert("Loading...", msg: "Please wait, loading the wordlist")
                return false
            }
            let query = textFieldQuery.text!
            if isQueryACommand(query)
            {
                mpdbShowErrorAlert("Command", msg: executeCommand(query))
                return false
            }
            if model.setAndValidateQuery(query)
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
    
    func stateChanged(_ newState: Model.States)
    {
        //update UI on main thread
        DispatchQueue.main.async
        {
            self.modelToView(newState)
        }
    }
    fileprivate func modelToView(_ state : Model.States)
    {
        switch state
        {
        case .uninitialized:
            self.searchButton.isEnabled=false
            let proFlag = self.model.settings.isProMode
            if !proFlag{
                //First time and only set up for ads
                Ads.createBannerView(vc: self)
            }
            self.title = proFlag ? "Anagram Solver Pro" : "Anagram Solver"
            let useProWordList = model.settings.useProWordList
            self.searchButton.title = useProWordList ? "Search+" : "Search"
            let resourceName = useProWordList ? "pro" : "standard"
            //load dictionary on a worker thread
            DispatchQueue.global(qos: .default).async
            {
                //There are two word lists pro and standard
                //pro contains all the words in standard
                //This approach takes more memory but is faster
                self.model.loadDictionary(resourceName)
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
    fileprivate func isQueryACommand(_ cmd : String) -> Bool
    {
        //Comment out this line to enable commands
        return false
//        return cmd.hasPrefix("-cmd")
    }
    fileprivate func executeCommand(_ cmd : String) -> String
    {
        if cmd == "-cmdpro"
        {
            self.model.proMode()
            return "Pro Mode On"
        }
        else if cmd == "-cmdstd"
        {
            self.model.stdMode()
            return "Std Mode On"
        }
        return "Bad Command"
    }
}
