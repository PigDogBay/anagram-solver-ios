//
//  DefinitionViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/04/2024.
//  Copyright © 2024 MPD Bailey Technology. All rights reserved.
//

import UIKit

class DefinitionViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!

    var word : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = word
    }

}
