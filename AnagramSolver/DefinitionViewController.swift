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
    
    var word : String!
    var definitionUrl : String!
    fileprivate var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: webViewContainer.frame)
        webView.navigationDelegate = self
        webViewContainer.addSubview(webView)
        constrainView(view: webView, toView: webViewContainer)
        
        navigationBar.title = word
        //replace space in two word anagrams with +
        let processedUrl = definitionUrl.replace(" ", withString: "+")
        let requestURL = URL(string: processedUrl)
        let request = URLRequest(url: requestURL!)
        webView.load(request)
        //Stop loading if the app is moved to the background
        NotificationCenter.default.addObserver(self, selector: #selector (appMovedToBackground), name: UIApplication.willResignActiveNotification, object: UIApplication.shared)
    }
    
    @objc func appMovedToBackground() {
        webView.stopLoading()
        loadingIndicator.stopAnimating()
        loadingLabel.isHidden=true
    }

    //https://stackoverflow.com/questions/40856112/how-to-create-a-sized-wkwebview-in-swift-3-ios-10
    func constrainView(view:UIView, toView contentView:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
        super.viewWillDisappear(animated)
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
        //https://stackoverflow.com/questions/34983144/strange-margin-in-wkwebview
        webView.scrollView.contentInset = .zero
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
