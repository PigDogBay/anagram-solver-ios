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
    var model : Model!
    
    let searchSegueId = "searchSegue"
    let goProSegueId = "goProSegue"
    let helpSegueId = "helpSegue"
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var textFieldQuery: UITextField!
    
 
    @IBAction func queryFinished(sender: UITextField) {
        if shouldPerformSegueWithIdentifier(searchSegueId, sender: self)
        {
            performSegueWithIdentifier(searchSegueId, sender: self)
        }
    }

    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let helpAction = UIAlertAction(title: "Help", style: .Default, handler: {action in self.showHelp()})
        let goProAction = UIAlertAction(title: "Go Pro", style: .Default, handler: {action in self.showGoPro()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        controller.addAction(helpAction)
        controller.addAction(goProAction)
        controller.addAction(cancelAction)
        
        //Anchor popover to button for iPads
        if let ppc = controller.popoverPresentationController{
            ppc.barButtonItem = menuButton
        }
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func showHelp(){
        performSegueWithIdentifier(helpSegueId, sender: self)
    }
    func showGoPro(){
        performSegueWithIdentifier(goProSegueId, sender: self)
    }
    

    @IBAction func backgroundTap(sender: UIControl) {
        //close the keyboard
        textFieldQuery.resignFirstResponder();
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        model = Model()
        model.addObserver("root", observer: self)
        modelToView(model.state)
    }
    override func viewDidAppear(animated: Bool)
    {
        if mpdbCheckIsFirstTime()
        {
            mpdbShowAlert("Welcome",msg: "Thanks for trying Anagram Solver, enter your letters and search over 130,000 words!")
        }
    }
    /*
    Recommended way to initialize child view controllers
    is here in prepareForSegue
    http://stackoverflow.com/questions/13279105/access-container-view-controller-from-parent-ios
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == searchSegueId
        {
            model.prepareToSearch()
            let matchesVC = segue.destinationViewController as! MatchesViewController
            matchesVC.model = self.model
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
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
    
    private func showErrorAlert(title: String, msg : String)
    {
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(action)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func stateChanged(newState: Model.States)
    {
        //update UI on main thread
        dispatch_async(dispatch_get_main_queue())
        {
            self.modelToView(newState)
        }
    }
    private func modelToView(state : Model.States)
    {
        switch state
        {
        case .uninitialized:
            self.searchButton.enabled=false
            //load dictionary on a worker thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                //There are two word lists pro and standard
                //pro contains all the words in standard
                //This approach takes more memory but is faster
                let resourceName = self.model.isProMode ? "pro" : "standard"
                self.model.loadDictionary(resourceName)
            }
        case .loading:
            self.searchButton.enabled=false
        case .ready:
            self.searchButton.enabled=true
        case .searching:
            self.searchButton.enabled=false
        case .finished:
            self.searchButton.enabled=true
        }
    }
    private func isQueryACommand(cmd : String) -> Bool
    {
        return cmd.hasPrefix("-cmd")
    }
    private func executeCommand(cmd : String) -> String
    {
        if cmd == "-cmdpro"
        {
            self.model.isProMode = true
            self.model.unloadDictionary()
            self.model.ads.noAds()
            return "Pro Mode On"
        }
        else if cmd == "-cmdstd"
        {
            self.model.isProMode = false
            self.model.unloadDictionary()
            self.model.ads.reset()
            return "Std Mode On"
        }
        return "Bad Command"
    }
}
