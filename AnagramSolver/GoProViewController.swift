//
//  GoProViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit

class GoProViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func stdBtnClick(sender: AnyObject)
    {
        model.stdMode()
        modelToView()
    }
    @IBAction func proBtnClicked(sender: AnyObject) {
        model.proMode()
        modelToView()
    }

    private var model : Model!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        modelToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modelToView(){
        statusLabel.text = model.isProMode ? "Pro" : "Standard"
    }

}
