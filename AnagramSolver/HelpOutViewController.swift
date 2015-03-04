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
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id375380948?mt=8")!)
    }
    
    @IBAction func tellFriendsBtnPressed(sender: UIButton)
    {
        if !MFMailComposeViewController.canSendMail()
        {
            self.mpdbShowErrorAlert("No Email", msg: "This device is not configured for sending emails.")
            return
        }
        var mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject("Anagram Solver")
        mailVC.setMessageBody("Check out this free new app for iPhone, iPad and iPod touch - now available in the App Store<br/><br/><b>Anagram Solver</b> Ideal for crosswords, scrabble and word puzzle games<br/><br/><a href=\"http://google.co.uk\">Available on the App Store</a><br/><br/><a href=\"http://play.google.com/store/apps/details?id=com.pigdogbay.anagramsolver\">Available for Android on Google Play</a><br/><br/><br/>Thanks", isHTML: true)
        presentViewController(mailVC, animated: true, completion: nil)
    }
    
    // MARK:- MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
    {
        //dismiss on send
        dismissViewControllerAnimated(true, completion: nil)
    }
}
