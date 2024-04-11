//
//  DefinitionViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/04/2024.
//  Copyright © 2024 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftUtils

class DefinitionViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!

    ///See book, SwiftUI Essentials 34.7 for embedding UIHostingController
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: DefinitionView(dictionary))
    }
    var word : String!
    var dictionary : WordDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = word
    }

}
