//
//  WordListCallbackAbstractFactory.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

protocol WordListCallbackAbstractFactory
{
    func createChainedCallback(lastCallback : WordListCallback) -> WordListCallback
}

class NullWLCAF : WordListCallbackAbstractFactory {
    func createChainedCallback(lastCallback: WordListCallback) -> WordListCallback {
        return lastCallback
    }
}
