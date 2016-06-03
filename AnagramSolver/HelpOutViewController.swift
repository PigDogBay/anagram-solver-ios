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

    @IBAction func rateBtnPressed(sender: UIButton)
    {
        //TO DO - insert own url
        UIApplication.sharedApplication().openURL(NSURL(string: Model.getAppUrl())!)
    }
    @IBAction func feedbackBtnPressed(sender: UIButton)
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
        presentViewController(mailVC, animated: true, completion: nil)    }
    
    @IBAction func tellFriendsBtnPressed(sender: UIButton)
    {
        if let rootVC = self.parentViewController?.parentViewController as! RootViewController!
        {
            rootVC.showGoPro()
        }

    }
    
    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        //dismiss on send
        dismissViewControllerAnimated(true, completion: nil)
    }
}
