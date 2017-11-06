//
//  FilterViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchClicked(_ sender: Any) {
    }
    
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    fileprivate var model : Model!
    fileprivate let numberCellId = "cellNumbersFilter"
    fileprivate let letterCellId = "cellLettersFilter"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        tableView.dataSource = self
        tableView.delegate = self


    }

    override func viewWillAppear(_ animated: Bool) {
        if model.settings.isProMode {
            bannerHeightConstraint.constant = 0
        } else {
            Ads.addAdView(container: bannerView)
        }
    }
    /*
     Table layout
     
     Filter By Letters
     [Contains |enter letters|]
     [Excludes |enter letters|]
     Letters can be in any order

     Prefix / Suffix
     [Prefix |enter letters|]
     [Suffix |enter letters|]
     Find words starting or ending with your specified letters.
     
     Filter By Word Size
     Equal to             5>
     Greater than   Not set>
     Less than      Not set>
     Press Search top right to perform a filter search

     */

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Filter By Letters"
        case 1:
            return "Prefix / Suffix"
        case 2:
            return "Filter By Word Size"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Letters can be in any order"
        case 1:
            return "Find words starting or ending with your specified letters."
        case 2:
            return "Press Search top right to perform a filter search"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0,0]:
            return cellForLettersFilter(indexPath, .contains)
        case [0,1]:
            return cellForLettersFilter(indexPath, .excludes)
        case [1,0]:
            return cellForLettersFilter(indexPath, .startsWith)
        case [1,1]:
            return cellForLettersFilter(indexPath, .endsWith)
        default:
            return tableView.dequeueReusableCell(withIdentifier: numberCellId, for: indexPath)
        }
    }
    fileprivate func cellForLettersFilter(_ indexPath: IndexPath, _ filterType : LettersFilterTableViewCell.FilterType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: letterCellId, for: indexPath) as! LettersFilterTableViewCell
        cell.bind(filter: model.filter, filterType: filterType)
        return cell
    }
    fileprivate func cellForNumbersFilter(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: numberCellId, for: indexPath)
        return cell
    }

}
