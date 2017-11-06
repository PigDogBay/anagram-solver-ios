//
//  LettersFilterTableViewCell.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class LettersFilterTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lettersTextView: UITextField!
    
    enum FilterType {
        case startsWith, endsWith, contains, excludes
    }
    
    fileprivate var filterType : FilterType?
    fileprivate var filter : Filter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
        Data binding is handled in this class as it seems the most convenient for now, similar to
        Android's ViewHolder.
        Ideally I would like to get rid of the enum and use reflection to pass in the field name
    */
    func bind(filter : Filter, filterType : FilterType){
        self.filter = filter
        self.filterType = filterType
        lettersTextView.delegate = nil

        switch filterType {
        case .startsWith:
            titleLabel.text = "Prefix"
            lettersTextView.text = filter.startingWith
        case .endsWith:
            titleLabel.text = "Suffix"
            lettersTextView.text = filter.endingWith
        case .contains:
            titleLabel.text = "Contains"
            lettersTextView.text = filter.containing
        case .excludes:
            titleLabel.text = "Excludes"
            lettersTextView.text = filter.excluding
        }
        lettersTextView.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let ft = filterType {
            switch ft {
            case .startsWith:
                filter?.startingWith = lettersTextView.text!
            case .endsWith:
                filter?.endingWith = lettersTextView.text!
            case .contains:
                filter?.containing = lettersTextView.text!
            case .excludes:
                filter?.excluding = lettersTextView.text!
            }
        }

    }
}
