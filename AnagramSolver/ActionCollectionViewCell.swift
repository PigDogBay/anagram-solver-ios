//
//  ActionCollectionViewCell.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class ActionCollectionViewCell: ShadowCollectionViewCell {
    var button1Callback : (() -> Void)?
    var button2Callback : (() -> Void)?
    var button3Callback : (() -> Void)?

    
    @IBAction func button1Clicked(_ sender: UIButton) {
        if let callback = button1Callback {
            callback()
        }
    }

    @IBAction func button2Clicked(_ sender: UIButton) {
        if let callback = button2Callback {
            callback()
        }
    }

    @IBAction func button3Clicked(_ sender: UIButton) {
        if let callback = button3Callback {
            callback()
        }
    }
}
