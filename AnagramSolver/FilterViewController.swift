//
//  FilterViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    @IBAction func searchClicked(_ sender: Any) {
        filterSearch()
    }
    

    @IBAction func unwindWithSelectedListItem(segue:UIStoryboardSegue) {
        if let vc = segue.source as? ListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let value = vc.selectedIndex {
                    switch indexPath {
                    case [4,0]:
                        model.filter.equalTo = value
                    case [4,1]:
                        model.filter.biggerThan = value
                    case [4,2]:
                        model.filter.lessThan = value
                    default:
                        break
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate var model : Model!
    fileprivate let numberCellId = "cellNumbersFilter"
    fileprivate let letterCellId = "cellLettersFilter"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        tableView.dataSource = self
        tableView.delegate = self


    }

    fileprivate func filterSearch() {
        if let navCtrl = self.navigationController {
            model.prepareToFilterSearch()
            navCtrl.popViewController(animated: true)
        }
    }
    
    /*
     Table layout
     
     Filter By Letters
     [Contains |enter letters|]
     [Excludes |enter letters|]
     Letters can be in any order

     Filter By Words
     [Contains |enter words|]
     [Excludes |enter words|]
     
     Prefix / Suffix
     [Prefix |enter letters|]
     [Suffix |enter letters|]
     Find words starting or ending with your specified letters.
     
     Pro Filters
     [Word Pattern | enter pattern]
     [Regular Expression : Enter regex]
     To create a pattern, use . to represent any letter and @ for 1 or more letters, eg s.r..b.e

     Filter By Word Size
     Equal to             5>
     Greater than   Not set>
     Less than      Not set>
     Press Search top right to perform a filter search

     */

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        case 3:
            return 2
        case 4:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Filter By Letters"
        case 1:
            return "Filter By Words"
        case 2:
            return "Prefix / Suffix"
        case 3:
            return "Pro Filters"
        case 4:
            return "Filter By Word Size"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Letters can be in any order here"
        case 1:
            return "Find words that contain a word"
        case 2:
            return "Find words starting or ending with your specified letters"
        case 3:
            return "To create a pattern, use . to represent any letter and @ for 1 or more letters, eg s.r..b.e"
        case 4:
            return "Press Search top right to perform a filter search"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0,0]:
            return cellForLettersFilter(indexPath, .contains)
        case [0,1]:
            return cellForLettersFilter(indexPath, .excludes)
        case [1,0]:
            return cellForLettersFilter(indexPath, .containsWord)
        case [1,1]:
            return cellForLettersFilter(indexPath, .excludesWord)
        case [2,0]:
            return cellForLettersFilter(indexPath, .startsWith)
        case [2,1]:
            return cellForLettersFilter(indexPath, .endsWith)
        case [3,0]:
            return cellForLettersFilter(indexPath, .crossword)
        case [3,1]:
            return cellForLettersFilter(indexPath, .regex)
        case [4,0]:
            return cellForNumbersFilter(indexPath, model.filter.equalTo, "Equal To")
        case [4,1]:
            return cellForNumbersFilter(indexPath, model.filter.biggerThan, "Greater Than")
        case [4,2]:
            return cellForNumbersFilter(indexPath, model.filter.lessThan, "Less Than")
        default:
            return tableView.dequeueReusableCell(withIdentifier: numberCellId, for: indexPath)
        }
    }
    fileprivate func cellForLettersFilter(_ indexPath: IndexPath, _ filterType : LettersFilterTableViewCell.FilterType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: letterCellId, for: indexPath) as! LettersFilterTableViewCell
        cell.bind(filter: model.filter, filterType: filterType)
        cell.searchPressed = filterSearch
        return cell
    }
    fileprivate func cellForNumbersFilter(_ indexPath: IndexPath,_ value : Int,_ title : String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: numberCellId, for: indexPath)
        cell.textLabel?.text = title;
        if value == 0 {
            cell.detailTextLabel?.text = "Not set"
        } else {
            cell.detailTextLabel?.text = "\(value) letters"
        }
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueShowNumberList":
            if let vc = segue.destination as? ListViewController {
                vc.listItems = ["No Filter","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
                vc.selectedIndex = 0
                if let selectedCell = sender as? UITableViewCell{
                    if let indexPath = tableView.indexPath(for: selectedCell) {
                        switch indexPath {
                        case [4,0]:
                            vc.title = "Equal To"
                            vc.selectedIndex = model.filter.equalTo
                        case [4,1]:
                            vc.title = "Greater Than"
                            vc.selectedIndex = model.filter.biggerThan
                        case [4,2]:
                            vc.title = "Less Than"
                            vc.selectedIndex = model.filter.lessThan
                        default:
                            break
                        }
                    }
                }
            }
        default:
            break
        }
    }
}
