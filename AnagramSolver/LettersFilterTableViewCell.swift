//
//  LettersFilterTableViewCell.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

protocol LettersCellCallback : AnyObject {
    func lettersCellReturnPressed();
}

class LettersFilterTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lettersTextView: UITextField!

    //Settings for the crossword pattern and query fields
    var convertSpaceToQuestionMark = false
    var convertFullStopToQuestionMark = false

    enum FilterType {
        case startsWith, endsWith, contains, excludes, containsWord, excludesWord, crossword, regex, query
    }
    
    weak var callback : LettersCellCallback?
    
    fileprivate var filterType : FilterType?
    fileprivate var filter : Filter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lettersTextView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /*
        Data binding is handled in this class as it seems the most convenient for now, similar to
        Android's ViewHolder.
    */
    func bind(filter : Filter, filterType : FilterType, isUpperCase : Bool = false){
        self.filter = filter
        self.filterType = filterType
        lettersTextView.delegate = nil
        lettersTextView.autocapitalizationType = isUpperCase ? .allCharacters : .none

        switch filterType {
        case .startsWith:
            titleLabel.text = "Prefix"
            lettersTextView.text = filter.startingWith
            lettersTextView.placeholder = "Enter prefix"
        case .endsWith:
            titleLabel.text = "Suffix"
            lettersTextView.text = filter.endingWith
            lettersTextView.placeholder = "Enter suffix"
        case .contains:
            titleLabel.text = "Contains"
            lettersTextView.text = filter.containing
            lettersTextView.placeholder = "Enter letters"
        case .excludes:
            titleLabel.text = "Excludes"
            lettersTextView.text = filter.excluding
            lettersTextView.placeholder = "Enter letters"
        case .containsWord:
            titleLabel.text = "Contains Word"
            lettersTextView.text = filter.containingWord
            lettersTextView.placeholder = "Enter word"
        case .excludesWord:
            titleLabel.text = "Excludes Word"
            lettersTextView.text = filter.excludingWord
            lettersTextView.placeholder = "Enter word"
        case .crossword:
            titleLabel.text = "Pattern "
            lettersTextView.text = filter.crossword
            lettersTextView.placeholder = "Enter pattern"
        case .regex:
            titleLabel.text = "Reg Exp"
            lettersTextView.text = filter.regex
            lettersTextView.placeholder = "Enter regex"
        case .query:
            titleLabel.text = "Query"
            lettersTextView.text = filter.query
            lettersTextView.placeholder = "Enter letters"
        }
        lettersTextView.delegate = self
    }
    
    //Update the filter immediately, textFieldDidEndEditing is called after model.prepareToFilterSearch
    @objc func textFieldDidChange(_ textField : UITextField){
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
            case .containsWord:
                filter?.containingWord = lettersTextView.text!
            case .excludesWord:
                filter?.excludingWord = lettersTextView.text!
            case .crossword:
                convertSpacesFullStopsToQuestionMarks()
                filter?.crossword = lettersTextView.text!
            case .regex:
                filter?.regex = lettersTextView.text!
            case .query:
                convertSpacesFullStopsToQuestionMarks()
                filter?.query = lettersTextView.text!
            }
        }
    }
        
    /// Depending on user settings, convert spaces to ?, convert . to ?
    private func convertSpacesFullStopsToQuestionMarks() {
        if convertSpaceToQuestionMark {
            lettersTextView.text = lettersTextView.text?.replacingOccurrences(of: " ", with: "?")
        }
        if convertFullStopToQuestionMark {
            lettersTextView.text = lettersTextView.text?.replacingOccurrences(of: ".", with: "?")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let completion = callback {
            completion.lettersCellReturnPressed()
        }
        return true
    }
}
