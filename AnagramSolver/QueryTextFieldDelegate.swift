//
//  QueryTextFieldDelegate.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 24/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import UIKit

class QueryTextFieldDelegate : NSObject, UITextFieldDelegate {
    var convertSpaceToQuestionMark = false
    var convertFullStopToQuestionMark = false

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (convertSpaceToQuestionMark && string == " "){
            textField.text?.append("?")
            return false
        }
        if (convertFullStopToQuestionMark && string == "."){
            textField.text?.append("?")
            return false
        }
        return true
    }
}
