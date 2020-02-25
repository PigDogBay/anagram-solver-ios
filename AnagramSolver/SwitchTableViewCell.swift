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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
