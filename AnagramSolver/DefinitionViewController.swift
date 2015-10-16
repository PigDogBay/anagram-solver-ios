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
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    var word : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove the gap above the web view
        self.automaticallyAdjustsScrollViewInsets = false

        let processedWord = stripUnusedChars(word)
        navigationBar.title=processedWord
        let requestURL = NSURL(string:"https://www.google.com/search?q=define:\(processedWord)")
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    deinit
    {
        //Doesn't get rid of the webview memory leak
        //not entirely sure if it helps
        webView.delegate = nil
        webView.removeFromSuperview()
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
        webView = nil
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        //testing with thegardian.co.uk
        // this can save 30Mb
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
    }
    
    private func stripUnusedChars(word : String) -> String
    {
        if word.mpdb_contains(" ")
        {
            let index = word.rangeOfString(" ")?.startIndex
            return word.substringToIndex(index!)
        }
        return word
    }
    
    //MARK:- Webview delegate functions
    //To make this class a delegate from the storyboard
    //In the webview connections inspector, connect delegate connection to view controller
    func webViewDidStartLoad(_ : UIWebView)
    {
        loadingIndicator.startAnimating()
        loadingLabel.hidden=false
    }
    func webViewDidFinishLoad(_ : UIWebView)
    {
        loadingIndicator.stopAnimating()
        loadingLabel.hidden=true
    }
}
