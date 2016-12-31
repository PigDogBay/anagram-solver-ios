//
//  HelpOutViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/03/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import MessageUI
import SwiftUtils

class HelpOutViewController : PageContentController, MFMailComposeViewControllerDelegate {

    @IBAction func rateBtnPressed(_ sender: UIButton)
    {
        //TO DO - insert own url
        UIApplication.shared.openURL(URL(string: Model.getAppUrl())!)
    }
    @IBAction func feedbackBtnPressed(_ sender: UIButton)
    {
        if !MFMailComposeViewController.canSendMail()
        {
            self.mpdbShowErrorAlert("No Email", msg: "This device is not configured for sending emails.")
            return
        }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject("Anagram Solver Feedback iOS")
        mailVC.setToRecipients(["pigdogbay@yahoo.co.uk"])
        mailVC.setMessageBody("Your feedback is most welcome\n *Report Bugs\n *Suggest new features\n *Ask for help\n\n\nHi Mark,\n\n[Enter you message here]", isHTML: false)
        present(mailVC, animated: true, completion: nil)    }
    
    @IBAction func tellFriendsBtnPressed(_ sender: UIButton)
    {
        if let rootVC = self.parent?.parent as! RootViewController!
        {
            rootVC.showGoPro()
        }

    }
    
    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        //dismiss on send
        dismiss(animated: true, completion: nil)
    }
}
