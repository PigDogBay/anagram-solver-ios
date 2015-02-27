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
    
    private var tipsPageVC : TipsPageViewController!
    
    let searchSegueId = "searchSegue"
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textFieldQuery: UITextField!
    
 
    @IBAction func queryFinished(sender: UITextField) {
        if shouldPerformSegueWithIdentifier(searchSegueId, sender: self)
        {
            performSegueWithIdentifier(searchSegueId, sender: self)
        }
    }

    @IBAction func showMePressed(sender: AnyObject)
    {
        if shouldPerformSegueWithIdentifier(searchSegueId, sender: self)
        {
            textFieldQuery.text = tipsPageVC.getSearchAction()
            performSegueWithIdentifier(searchSegueId, sender: self)
        }
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
        println("RootVC loaded")
        model = Model(resourceName: "standard")
        model.addObserver("root", observer: self)
        modelToView(model.state)
    }
    
    
    /*
    Recommended way to initialize child view controllers
    is here in prepareForSegue
    http://stackoverflow.com/questions/13279105/access-container-view-controller-from-parent-ios
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //remember to set the segue identifier in the storyboard
        if segue.identifier == "TipsSegue"
        {
            self.tipsPageVC = segue.destinationViewController as TipsPageViewController
        }
        else if segue.identifier == searchSegueId
        {
            self.model.query = textFieldQuery.text
            let matchesVC = segue.destinationViewController as MatchesViewController
            matchesVC.model = self.model
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        if searchSegueId == identifier
        {
            if !model.isReady()
            {
                //show error
                return false
            }
            let query = textFieldQuery.text
            if model.validateQuery(query)
            {
                println("3")
                return true
            }
            else
            {
                //show error
                return false
            }
        }
        
        return true
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
                self.model.loadDictionary()
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
}
