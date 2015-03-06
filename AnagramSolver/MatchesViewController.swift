//
//  MatchesViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 27/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import iAd

class MatchesViewController: UIViewController, StateChangeObserver, WordSearchObserver, UITableViewDataSource
{
    private let cellIdentifier = "MatchesCell"
    var model : Model!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var matchesTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBAction func shareButton(sender: UIBarButtonItem)
    {
        let firstActivityItem = model.share()
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        //For iPads need to anchor the popover to the right bar button, crashes if not set
        activityViewController.popoverPresentationController?.barButtonItem = navBar.rightBarButtonItem
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        println("MatchesVC loaded")
        //Add iAd.Framework in the project page-> general tab->Linked frameworks and libraries
        //import iAd
        //Set extension property canDisplayBannerAds to true
        //A parent View is created to hold this view and the ad will appear from below
        self.canDisplayBannerAds = true
        
        self.stateChanged(model.state)
        model.addObserver("matches", observer: self)
        model.wordSearchObserver = self
    }
    override func viewDidAppear(animated: Bool)
    {
        //Run worker thread here as if started in viewDidLoad
        //the ui may not be ready for when a match comes in
        if model.state == .ready
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                self.model.search()
            }
        }
    }
    override func willMoveToParentViewController(parent: UIViewController?)
    {
        println("MatchesVC gooing back")
        self.canDisplayBannerAds = false
        model.stop()
        model.removeObserver("matches")
        model.wordSearchObserver = nil
    }
    deinit
    {
        println("MatchesVC unloaded")
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "definitionSegue"
        {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Matches", style:.Plain, target:nil, action:nil)
            self.canDisplayBannerAds = false
            let definitionVC = segue.destinationViewController as DefinitionViewController
            let cell = sender as UITableViewCell
            definitionVC.word = cell.textLabel?.text
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = model.matches[indexPath.row]
        return cell
    }

    
    // MARK: - StateChangeObserver Conformance
    func stateChanged(newState: Model.States)
    {
        //update UI on main thread
        dispatch_async(dispatch_get_main_queue())
        {
            self.modelToView(newState)
        }
    }
    // MARK: - WordSearchObserver Conformance
    func matchFound(match: String)
    {
        //update UI on main thread
        dispatch_sync(dispatch_get_main_queue())
        {
            self.matchesTable.reloadData()
        }
    }
    private func modelToView(state : Model.States)
    {
        switch state
        {
        case .uninitialized:
            break
        case .loading:
            break
        case .ready:
            navBar.title = model.query
            fallthrough
        case .searching:
            statusLabel.text = "Searching..."
            navBar.rightBarButtonItem?.enabled=false
        case .finished:
            statusLabel.text = "Matches: \(model.matches.count)"
            matchesTable.reloadData()
            navBar.rightBarButtonItem?.enabled=true
        }
    }
 
}
