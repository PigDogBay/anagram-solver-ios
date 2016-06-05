//
//  HelpViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    private var webView: WKWebView?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSBundle.mainBundle().URLForResource("help", withExtension: "html") {
            if #available(iOS 9.0, *) {
                webView?.loadFileURL(url,allowingReadAccessToURL: url)
            } else {
                // To Do: Fallback on earlier versions
                self.mpdbShowErrorAlert("Not Supported", msg: "Help is only available for iOS 9 onwards")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
