//
//  RootViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 23/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUtils

class RootViewController: UIViewController
{
    var model : Model!
    
    private var tipsPageVC : TipsPageViewController!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textFieldQuery: UITextField!
    

    @IBAction func doneEditing(sender: UITextField) {
    }
    
    @IBAction func searchBtnPressed(sender: AnyObject) {
    }
    @IBAction func showMePressed(sender: AnyObject) {
        textFieldQuery.text = tipsPageVC.getSearchAction()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        model = Model()
        loadDictionary()
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadDictionary()
    {
        //update UI to show dictionary is loading
        self.searchButton.enabled=false
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
                self.model.loadDictionary()
                dispatch_async(dispatch_get_main_queue())
                {
                    //Update UI to show dictionary has loaded
                    self.searchButton.enabled=true
                }
        }
    }
}
