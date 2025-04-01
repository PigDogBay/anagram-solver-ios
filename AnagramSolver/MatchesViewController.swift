//
//  MatchesViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 27/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftUtils
import AVFoundation
import UserMessagingPlatform

class MatchesViewController: UIViewController, AppStateChangeObserver, UITableViewDataSource, UITableViewDelegate, BannerViewDelegate
{
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    fileprivate let cellIdentifier = "MatchesCell"
    fileprivate let cellIdentifierLarge = "MatchesCellLarge"
    fileprivate let definitionSegueId = "showDefinitionSegue"
    fileprivate var model : Model!
    fileprivate var selectedWord = ""
    private lazy var synthesizer : AVSpeechSynthesizer = {
        AVSpeechSynthesizer()
    }()

    private var screenWidth : CGFloat {
        return view.frame.inset(by: view.safeAreaInsets).size.width
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var matchesTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bannerContainerView: UIView!
    private var bannerView : BannerView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.model = Model.sharedInstance

        //Remove blank gap at the bottom of the screen whilst Ad is loading
        bannerHeightConstraint.constant = 0
        if model.settings.isLongPressEnabled {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MatchesViewController.handleLongPress))
            matchesTable.addGestureRecognizer(longPress)
        }
        //Stop any search if the app is moved to the background
        NotificationCenter.default.addObserver(self, selector: #selector (appMovedToBackground), name: UIApplication.willResignActiveNotification, object: UIApplication.shared)

    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
          self.loadAd()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        //show .ready state, needs to done here as pressing search on filter does not call viewDidLoad but will call this function.
        self.modelToView( model.appState.appState)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // Note loadBannerAd is called in viewDidAppear as this is the first time that
        // the safe area is known. If safe area is not a concern (e.g., your app is
        // locked in portrait mode), the banner can be loaded in viewWillAppear.
        loadAd()
        model.appState.addObserver(observer: self)
        //expect to be in ready state when search has been pressed from main VC or filter VC
        if model.appState.appState == .ready
        {
            DispatchQueue.global(qos: .userInitiated).async
            {
                self.model.search()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        model.stop()
        model.appState.removeObserver(observer: self)
        super.viewWillDisappear(animated)
    }
    //
    // This function is called twice, first when child view is added to parent
    // then secondly when it is removed, in this case parent is nil
    //
    override func willMove(toParent parent: UIViewController?)
    {
        //Only do something when moving back to parent
        if parent == nil
        {
            Model.sharedInstance.ratings.requestRating()
        }
    }
    @objc func appMovedToBackground() {
        self.model.stop()
    }

    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.matchesTable)
            if let indexPath = matchesTable.indexPathForRow(at: touchPoint){
                if let word = model.matches.getMatch(section: indexPath.section, row: indexPath.row){
                    showLookUpDefinitionMenu(word: word, location : touchPoint)
                }
            }
        }
    }
    
    private func loadAd(){
        if !model.settings.isProMode && ConsentInformation.shared.canRequestAds
        {
            print("Loading Ad")
            //Set up bannerView height for the device
            //Another method is to set the bannerHeightConstraint relation to be greater than or equal to 0
            //but IB complains about ambiguous constraints
            let adSize = Ads.createAdsize(screenWidth: screenWidth)
            //Remove old ads
            bannerView?.removeFromSuperview()
            bannerView = nil
            bannerHeightConstraint.constant = 0
            self.bannerView = BannerView(adSize: adSize)
            bannerView?.adUnitID = Ads.bannerAdId
            bannerView?.rootViewController = self
            bannerView?.delegate = self
            bannerView?.load(Ads.createRequest())
        }
    }
    
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("Ad Loaded")
        if bannerContainerView.subviews.isEmpty {
            print("Adding SubView")
            bannerHeightConstraint.constant = bannerView.adSize.size.height
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerContainerView.addSubview(bannerView)
            // Constraints to center the banner within adContainerView
            bannerView.centerXAnchor.constraint(equalTo: bannerContainerView.centerXAnchor).isActive = true
            bannerView.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor).isActive = true
        }
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("Failed to load ad: \(error.localizedDescription)")
    }
    func shortenWord(word : String, maxSize : Int) -> String {
        if word.length <= maxSize {
            return word
        }
        return word[..<word.index(word.startIndex, offsetBy: maxSize)]+".."
    }
    
    func showLookUpDefinitionMenu(word : String, location : CGPoint){
        let shortenedWord = shortenWord(word: word, maxSize: 12)
        let lookUp = LookUpUrl(word: word)
        let controller = UIAlertController(title: "Look up "+shortenedWord, message: nil, preferredStyle: .actionSheet)
        
        let speakAction = UIAlertAction(title: "Speak", style: .default,
                                        handler: {action in mpdbSpeak(synth: self.synthesizer, text: word)})
        let collinsAction = UIAlertAction(title: "Collins", style: .default,
                                          handler: {action in self.showWebPage(lookUp.collins)})
        let dictionaryComAction = UIAlertAction(title: "Dictionary.com", style: .default,
                                                handler: {action in self.showWebPage(lookUp.dictionaryCom)})
        let googleAction = UIAlertAction(title: "Google Dictionary", style: .default,
                                         handler: {action in self.showWebPage(lookUp.googleDictionary)})
        let merriamWebsterAction = UIAlertAction(title: "Merriam-Webster", style: .default,
                                                 handler: {action in self.showWebPage(lookUp.merriamWebster)})
        let mwThesaurusAction = UIAlertAction(title: "M-W Thesaurus", style: .default,
                                              handler: {action in self.showWebPage(lookUp.merriamWebsterThesaurus)})
        let thesaurusAction = UIAlertAction(title: "Thesaurus.com", style: .default,
                                            handler: {action in self.showWebPage(lookUp.thesaurusCom)})
        let wiktionaryAction = UIAlertAction(title: "Wiktionary", style: .default,
                                             handler: {action in self.showWebPage(lookUp.wikionary)})
        let wikipediaAction = UIAlertAction(title: "Wikipedia", style: .default,
                                            handler: {action in self.showWebPage(lookUp.wikipedia)})
        let wordGameAction = UIAlertAction(title: "Word Game Dictionary", style: .default,
                                           handler: {action in self.showWebPage(lookUp.wordGameDictionary)})
        
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler: {action in UIPasteboard.general.string = word})
        let copyAllAction = UIAlertAction(title: "Copy All", style: .default, handler: {action in
            UIPasteboard.general.string = self.model.copyAll()})

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(speakAction)
        controller.addAction(collinsAction)
        controller.addAction(dictionaryComAction)
        controller.addAction(googleAction)
        controller.addAction(merriamWebsterAction)
        controller.addAction(mwThesaurusAction)
        controller.addAction(thesaurusAction)
        controller.addAction(wiktionaryAction)
        controller.addAction(wikipediaAction)
        controller.addAction(wordGameAction)
        controller.addAction(copyAction)
        controller.addAction(copyAllAction)
        controller.addAction(cancelAction)

        //Anchor popover to button for iPads
        if let ppc = controller.popoverPresentationController{
	        ppc.sourceView = matchesTable
            ppc.sourceRect = CGRect(origin: location, size: CGSize(width: 1, height: 1))
        }
        present(controller, animated: true, completion: nil)
    }
    private func showWebPage(_ address : String) {
        if let url = URL(string: address) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if model != nil {
            model.stop()
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return model.matches.sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.matches.getNumberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellId = model.settings.useLargeResultsFont ? cellIdentifierLarge : cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        cell.accessoryType = .detailButton
        let word = model.matches.getMatch(section: indexPath.section, row: indexPath.row) ?? ""
        model.wordFormatter.setLabelText(cell.textLabel, word)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let word = model.matches.getMatch(section: indexPath.section, row: indexPath.row) {
            let lookUpResult = model.lookUpDefinition(word)
            if (lookUpResult.isDefinitionAvailable) {
                selectedWord = word
                performSegue(withIdentifier: self.definitionSegueId, sender: self)
            } else {
                //No definition found, so open a web browser to search for it
                let url = model.settings.getDefinitionUrl(word: word)
                showWebPage(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(model.matches.getNumberOfLetters(section: section)) letters"
    }

    ///These two functions allow the row height to increase with Accessibility font size
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return model.matches.sectionTitles
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.definitionSegueId
        {
            if let definitionVC = segue.destination as? DefinitionViewController {
                definitionVC.word = self.selectedWord
                definitionVC.dictionary = model
            }
        }
    }
    
    // MARK: - StateChangeObserver Conformance
    func appStateChanged(_ newState: AppStates)
    {
        //update UI on main thread
        DispatchQueue.main.async
        {
            self.modelToView(newState)
        }
    }

    fileprivate func modelToView(_ state : AppStates)
    {
        switch state
        {
        case .uninitialized:
            break
        case .loading:
            break
        case .ready:
            navBar.title = model.casedQuery
            //clear matches when doing a filter search
            self.matchesTable.reloadData()
            fallthrough
        case .searching:
            statusLabel.text = "Searching..."
            navBar.rightBarButtonItem?.isEnabled=false
        case .finished:
            if model.filter.filterCount>0{
                statusLabel.text = "Matches: \(model.matches.count) Filters: \(model.filter.filterCount)"
            } else {
                statusLabel.text = "Matches: \(model.matches.count)"
            }
            model.matches.groupBySize()
            matchesTable.reloadData()
            navBar.rightBarButtonItem?.isEnabled=true
        case .error:
            mpdbShowAlert(Strings.errorTitle, msg: Strings.errorMessage)
        }
    }
    
}

extension WordFormatter {
    public func setLabelText(_ label: UILabel?, _ word : String) {
        let caseWord = isUpperCased ? word.uppercased() : word
        if isAttributed {
            label?.attributedText = formatAttributed(caseWord)
        } else {
            label?.text = format(caseWord)
        }
    }
}
