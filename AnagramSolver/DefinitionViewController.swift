//
//  DefinitionViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 23/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import WebKit

class DefinitionViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var word : String!
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.insertSubview(webView, atIndex: 0)

        let processedWord = stripUnusedChars(word)
        navigationBar.title=processedWord
        let requestURL = NSURL(string:"https://www.google.com/search?q=define:\(processedWord)")
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    override func viewWillDisappear(animated: Bool) {
        webView.stopLoading()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        webView.stopLoading()
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
    
    
    
    //MARK:- WKNavigationDelegate
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        loadingLabel.hidden=false
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        loadingLabel.hidden=true
    }
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        loadingIndicator.stopAnimating()
        loadingLabel.hidden=true
    }
    
    
}
