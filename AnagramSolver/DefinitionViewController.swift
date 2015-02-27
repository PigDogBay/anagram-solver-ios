//
//  DefinitionViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 23/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class DefinitionViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var word : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove the gap above the web view
        self.automaticallyAdjustsScrollViewInsets = false

        let processedWord = stripUnusedChars(word)
        let requestURL = NSURL(string:"http://www.google.com/search?q=define:\(processedWord)")
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func stripUnusedChars(word : String) -> String
    {
        if word.mpdb_contains(" ")
        {
            let index = word.rangeOfString(" ")
            return word.substringToIndex(advance(index!.endIndex,-1))
        }
        return word
    }
}
