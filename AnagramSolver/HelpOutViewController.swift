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
        if !MFMailComposeViewController.canSendMail()
        {
            self.mpdbShowErrorAlert("No Email", msg: "This device is not configured for sending emails.")
            return
        }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject("Anagram Solver")
        mailVC.setMessageBody("Check out this free new app for iPhone, iPad and iPod touch - now available in the App Store<br/><br/><b>Anagram Solver</b> Ideal for crosswords, scrabble and word puzzle games<br/><br/><a href=\""+Model.getAppWebUrl()+"\">Available on the App Store</a><br/><br/><a href=\"http://play.google.com/store/apps/details?id=com.pigdogbay.anagramsolver\">Available for Android on Google Play</a><br/><br/><br/>Thanks", isHTML: true)
        presentViewController(mailVC, animated: true, completion: nil)
    }
    
    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        //dismiss on send
        dismissViewControllerAnimated(true, completion: nil)
    }
}
