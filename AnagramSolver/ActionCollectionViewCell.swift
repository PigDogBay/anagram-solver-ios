//
//  ActionCollectionViewCell.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    var button1Callback : (() -> Void)?
    var button2Callback : (() -> Void)?

    
    @IBAction func button1Clicked(_ sender: UIButton) {
        print("Button 1 clicked")
        if let callback = button1Callback {
            callback()
        }
    }

    @IBAction func button2Clicked(_ sender: UIButton) {
        print("Button 2 clicked")
        if let callback = button2Callback {
            callback()
        }
    }

}
