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
    var definitionUrl : String!
    fileprivate var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.insertSubview(webView, at: 0)

        let processedWord = stripUnusedChars(word)
        navigationBar.title=processedWord
        let requestURL = URL(string: definitionUrl)
        let request = URLRequest(url: requestURL!)
        webView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        webView.stopLoading()
    }
    
    fileprivate func stripUnusedChars(_ word : String) -> String
    {
        if word.mpdb_contains(" ")
        {
            let index = word.range(of: " ")?.lowerBound
            return word.substring(to: index!)
        }
        return word
    }
    
    
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        loadingLabel.isHidden=false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        loadingLabel.isHidden=true
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        loadingLabel.isHidden=true
    }
    
    
}
