//
//  RootViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 23/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUtils

class RootViewController: UIViewController, StateChangeObserver
{
    fileprivate var model : Model!
    
    let searchSegueId = "searchSegue"
    let goProSegueId = "goProSegue"
    let helpSegueId = "helpSegue"
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var textFieldQuery: UITextField!
    
 
    @IBAction func queryFinished(_ sender: UITextField) {
        if shouldPerformSegue(withIdentifier: searchSegueId, sender: self)
        {
            performSegue(withIdentifier: searchSegueId, sender: self)
        }
    }

    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let helpAction = UIAlertAction(title: "Help", style: .default, handler: {action in self.showHelp()})
        let goProAction = UIAlertAction(title: "Go Pro", style: .default, handler: {action in self.showGoPro()})
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in self.showSettings()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if #available(iOS 9.0, *) {
            controller.addAction(helpAction)
        }
        controller.addAction(goProAction)
        controller.addAction(settingsAction)
        controller.addAction(cancelAction)
        
        //Anchor popover to button for iPads
        if let ppc = controller.popoverPresentationController{
            ppc.barButtonItem = menuButton
        }
        
        present(controller, animated: true, completion: nil)
        
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
    func appEnterForgeround() {
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
                showErrorAlert("Loading...", msg: "Please wait, loading the wordlist")
                return false
            }
            let query = textFieldQuery.text!
            if isQueryACommand(query)
            {
                showErrorAlert("Command", msg: executeCommand(query))
                return false
            }
            if model.setAndValidateQuery(query)
            {
                return true
            }
            else
            {
                showErrorAlert("Search Error", msg: "Please enter letters a to z")
                return false
            }
        }
        
        return true
    }
    
    fileprivate func showErrorAlert(_ title: String, msg : String)
    {
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
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
            if proFlag {
                model.ads.noAds()
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
//        return false
        return cmd.hasPrefix("-cmd")
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
