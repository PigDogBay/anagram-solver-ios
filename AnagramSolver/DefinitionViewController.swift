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
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    var word : String!
    var definitionUrl : String!
    fileprivate var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: webViewContainer.bounds)
        webView.navigationDelegate = self
        webViewContainer.insertSubview(webView, at: 0)

        navigationBar.title = word
        //replace space in two word anagrams with +
        let processedUrl = definitionUrl.replace(" ", withString: "+")
        let requestURL = URL(string: processedUrl)
        let request = URLRequest(url: requestURL!)
        webView.load(request)
    }

    override func viewWillAppear(_ animated: Bool) {
        if Model.sharedInstance.settings.isProMode {
            bannerHeightConstraint.constant = 0
        } else {
            Ads.addAdView(container: bannerView)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        webView.stopLoading()
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
