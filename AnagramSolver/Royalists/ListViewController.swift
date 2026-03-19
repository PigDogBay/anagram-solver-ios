//
//  ListViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var id = 0
    var listItems : [String]!
    var selectedIndex : Int?
    var selectedItem : String? {
        didSet {
            if let item = selectedItem {
                selectedIndex = listItems.firstIndex(of: item)
            }
        }
    }
    
    let cellReuseId = "cellListItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        cell.textLabel?.text = listItems[indexPath.row]
        cell.accessoryType = .none
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    ///These two functions allow the row height to increase with Accessibility font size
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)
            if let index = indexPath?.row{
                self.selectedIndex = index
                self.selectedItem = listItems[index]
            }
        }
    }

}
