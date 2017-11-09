//
//  TipCollectionViewCell.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 07/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class TipCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
       
    @IBAction func showMeClicked(_ sender: UIButton) {
    }
    
    func setDescription(string : String){
        let attrString = NSMutableAttributedString(string: string)
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 0
        paraStyle.lineHeightMultiple = 1.5
        paraStyle.alignment = .left
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paraStyle, range:NSMakeRange(0, attrString.length))
        descriptionLabel.attributedText = attrString
    }
}
