//
//  MatchesViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 27/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MatchesViewController: UIViewController, StateChangeObserver, WordSearchObserver, UITableViewDataSource
{
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    fileprivate let cellIdentifier = "MatchesCell"
    fileprivate var model : Model!

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var matchesTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBAction func shareButton(_ sender: UIBarButtonItem)
    {
        let firstActivityItem = model.share()
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        //For iPads need to anchor the popover to the right bar button, crashes if not set
        if let ppc = activityViewController.popoverPresentationController {
            ppc.barButtonItem = navBar.rightBarButtonItem
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        
        if model.isProMode
        {
            bannerHeightConstraint.constant = 0
       
        }
        else
        {
            bannerView.adUnitID = Ads.getBannerAdId()
            bannerView.rootViewController = self
            bannerView.load(Ads.createRequest())
        }

        self.stateChanged(model.state)
        model.addObserver("matches", observer: self)
        model.wordSearchObserver = self
    }
    override func viewDidAppear(_ animated: Bool)
    {
        //Run worker thread here as if started in viewDidLoad
        //the ui may not be ready for when a match comes in
        if model.state == .ready
        {
            DispatchQueue.global(qos: .default).async
            {
                self.model.search()
            }
        }
    }
    //
    // This function is called twice, first when child view is added to parent
    // then secondly when it is removed, in this case parent is nil
    //
    override func willMove(toParentViewController parent: UIViewController?)
    {
        //Only do something when moving back to parent
        if parent == nil
        {
            model.stop()
            model.removeObserver("matches")
            model.wordSearchObserver = nil
            if !model.isProMode
            {
                model.ads.showInterstitial(self.parent!)
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        model.stop()
        model.wordSearchObserver = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "definitionSegue"
        {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
            let definitionVC = segue.destination as! DefinitionViewController
            let cell = sender as! UITableViewCell
            definitionVC.word = cell.textLabel?.text
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = model.matches[indexPath.row]
        return cell
    }

    
    // MARK: - StateChangeObserver Conformance
    func stateChanged(_ newState: Model.States)
    {
        //update UI on main thread
        DispatchQueue.main.async
        {
            self.modelToView(newState)
        }
    }
    // MARK: - WordSearchObserver Conformance
    func matchFound(_ match: String)
    {
        //update UI on main thread
        DispatchQueue.main.sync
        {
            self.matchesTable.reloadData()
        }
    }
    fileprivate func modelToView(_ state : Model.States)
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
            navBar.rightBarButtonItem?.isEnabled=false
        case .finished:
            statusLabel.text = "Matches: \(model.matches.count)"
            matchesTable.reloadData()
            navBar.rightBarButtonItem?.isEnabled=true
        }
    }
 
}
