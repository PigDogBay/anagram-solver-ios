//
//  AboutViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 29/11/2019.
//  Copyright © 2019 MPD Bailey Technology. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var relevantAdsLabel: UILabel!
    @IBOutlet weak var relevantAdsSwitch: UISwitch!
    @IBAction func buyBtnClicked(_ sender: UIButton) {
        print("buy clicked")
    }
    @IBAction func restoreBtnClicked(_ sender: UIButton) {
        print("restore clicked")
    }
    @IBAction func privacyPolicyBtnClicked(_ sender: UIButton) {
        print("privacy policy clicked")
    }
    @IBAction func findOutMoreBtnClicked(_ sender: UIButton) {
        print("find out more clicked")
    }
    @IBAction func relevantAdsSwitchClicked(_ sender: UISwitch) {
        print("relevant ads clicked")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
