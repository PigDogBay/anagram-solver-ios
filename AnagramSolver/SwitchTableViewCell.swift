//
//  SwitchTableViewCell.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/02/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl : UISwitch!
    @IBAction func switchClicked(_ sender: UISwitch) {
        if let callback = switchClickedCallback{
            callback(switchControl.isOn)
        }
    }
    var switchClickedCallback : ((_ isOn : Bool) -> Void)?
}
