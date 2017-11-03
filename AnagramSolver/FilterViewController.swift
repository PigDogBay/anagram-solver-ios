//
//  FilterViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchClicked(_ sender: Any) {
    }
    
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    fileprivate var model : Model!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance

    }

    override func viewWillAppear(_ animated: Bool) {
        if model.settings.isProMode {
            bannerHeightConstraint.constant = 0
        } else {
            Ads.addAdView(container: bannerView)
        }
    }

}
