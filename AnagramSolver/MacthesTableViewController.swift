//
//  MacthesTableViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 23/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class MacthesTableViewController: UITableViewController, StateChangeObserver, WordSearchObserver {

    @IBOutlet weak var statusLabel: UILabel!
    private let cellIdentifier = "Matches"
    var model : Model!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        println("MatchesVC loaded")
        model.addObserver("matches", observer: self)
        model.wordSearchObserver = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            self.model.search()
        }
    }
    override func willMoveToParentViewController(parent: UIViewController?) {
        println("MatchesVC gooing back")
        model.stop()
        model.removeObserver("matches")
        model.wordSearchObserver = nil
    }
    deinit
    {
        println("MatchesVC unloaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.matches.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
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
            self.tableView.reloadData()
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
            break
        case .searching:
            navigationBar.title = "Searching..."
        case .finished:
            navigationBar.title = "Matches: \(model.matches.count)"
            tableView.reloadData()
        }
    }

}
