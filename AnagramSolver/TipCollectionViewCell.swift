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
    
    var query : String!
    var showMeCallback : ((_ query : String) -> Void)?
    
    @IBAction func showMeClicked(_ sender: UIButton) {
        if let completion = showMeCallback {
            completion(query)
        }
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
    
    //https://stackoverflow.com/questions/18113872/uicollectionviewcell-with-rounded-corners-and-drop-shadow-not-working
    override func layoutSubviews() {
        self.layer.cornerRadius = 2.0
        //Shadow effect
        //        cell.contentView.layer.borderWidth = 1.0
        //        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        //        cell.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
