//
//  Coordinator.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils
import Combine

///Deals with interactions between views and holds shared observed variables
class Coordinator : ObservableObject {

    let rootVC : RootViewController
    @Published var showMeRelevantAds = true

    init(rootVC : RootViewController)
    {
        self.rootVC = rootVC
    }
    
    func showHelpExample(example : String){
        rootVC.showMe(query: example)
    }

}

