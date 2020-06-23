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

class MatchesViewController: UIViewController, AppStateChangeObserver, MatchFoundObserver, UITableViewDataSource
{
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    fileprivate let cellIdentifier = "MatchesCell"
    fileprivate var model : Model!
    fileprivate var selectedWord = ""
    fileprivate var wordDefinitionUrl = ""
    
    let definitionSegueId = "definitionSegue"
    static let monospacedFont = UIFont(name: "Menlo-Regular",size: 20.0)
    static let systemFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)

    private var screenWidth : CGFloat {
        return view.frame.inset(by: view.safeAreaInsets).size.width
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var matchesTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.model = Model.sharedInstance

        if model.settings.isProMode
        {
            bannerHeightConstraint.constant = 0
        }
        else
        {
            bannerView.adUnitID = Ads.bannerAdId
            bannerView.rootViewController = self
        }

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
        model.matches.setMatchesObserver(observer: self)
        //expect to be in ready state when search has been pressed from main VC or filter VC
        if model.appState.appState == .ready
        {
            DispatchQueue.global(qos: .default).async
            {
                self.model.search()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        model.stop()
        model.appState.removeObserver(observer: self)
        model.matches.removeMatchObserver()
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
                if let word = model.getWord(atIndex: indexPath.row){
                    showLookUpDefinitionMenu(word: word, location : touchPoint)
                }
            }
        }
    }
    
    private func loadAd(){
        if !model.settings.isProMode
        {
            //Set up bannerView height for the device
            //Another method is to set the bannerHeightConstraint relation to be greater than or equal to 0
            //but IB complains about ambiguous constraints
            let adSize = Ads.createAdsize(screenWidth: screenWidth)
            bannerHeightConstraint.constant = adSize.size.height
            bannerView.adSize = adSize
            bannerView.load(Ads.createRequest(useNpa: model.settings.useNonPersonalizedAds))
        }
    }
    
    func shortenWord(word : String, maxSize : Int) -> String {
        if word.length <= maxSize {
            return word
        }
        return word[..<word.index(word.startIndex, offsetBy: maxSize)]+".."
    }
    
    func showLookUpDefinitionMenu(word : String, location : CGPoint){
        let shortenedWord = shortenWord(word: word, maxSize: 12)
        let controller = UIAlertController(title: "Look up "+shortenedWord, message: nil, preferredStyle: .actionSheet)

        let collinsAction = UIAlertAction(title: "Collins", style: .default,
                                             handler: {action in self.showDefinition(word: word, url: WordSearch.getCollinsUrl(word: word))})
        let dictionaryComAction = UIAlertAction(title: "Dictionary.com", style: .default,
                                         handler: {action in self.showDefinition(word: word, url: WordSearch.getDictionaryComUrl(word: word))})
        let googleAction = UIAlertAction(title: "Google Definition", style: .default,
                                         handler: {action in self.showDefinition(word: word, url: WordSearch.getGoogleDefineUrl(word: word))})
        let lexicoAction = UIAlertAction(title: "Lexico", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getLexicoUrl(word: word))})
        let merriamWebsterAction = UIAlertAction(title: "Merriam-Webster", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getMerriamWebsterUrl(word: word))})
        let mwThesaurusAction = UIAlertAction(title: "M-W Thesaurus", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getMWThesaurusUrl(word: word))})
        let thesaurusAction = UIAlertAction(title: "Thesaurus.com", style: .default,
                                             handler: {action in self.showDefinition(word: word, url: WordSearch.getThesaurusComUrl(word: word))})
        let wiktionaryAction = UIAlertAction(title: "Wiktionary", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getWiktionaryUrl(word: word))})
        let wikipediaAction = UIAlertAction(title: "Wikipedia", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getWikipediaUrl(word: word))})
        let wordGameAction = UIAlertAction(title: "Word Game Dictionary", style: .default,
                                         handler: {action in self.showDefinition(word: word, url: WordSearch.getWordGameDictionaryUrl(word: word))})
        
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler: {action in UIPasteboard.general.string = word})
        let copyAllAction = UIAlertAction(title: "Copy All", style: .default, handler: {action in
            UIPasteboard.general.string = self.model.copyAll()})

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(collinsAction)
        controller.addAction(dictionaryComAction)
        controller.addAction(googleAction)
        controller.addAction(lexicoAction)
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
    
    func showDefinition(word : String, url : String){
        self.selectedWord = word;
        self.wordDefinitionUrl = url;
        performSegue(withIdentifier: self.definitionSegueId, sender: self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        model.stop()
        model.matches.removeMatchObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.definitionSegueId
        {
            if let definitionVC = segue.destination as? DefinitionViewController {
                if let cell = sender as? UITableViewCell {
                    //Cell icon press
                    if let indexPath = matchesTable.indexPath(for: cell) {
                        if let word = model.getWord(atIndex: indexPath.row) {
                            definitionVC.word = word
                            definitionVC.definitionUrl = model.settings.getDefinitionUrl(word: word)
                        }
                    }
                } else {
                    //long press
                    definitionVC.word = selectedWord
                    definitionVC.definitionUrl = wordDefinitionUrl
                }
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        cell.accessoryType = .detailButton
        cell.textLabel?.font = model.settings.useMonospacedFont ? MatchesViewController.monospacedFont : MatchesViewController.systemFont
        let word = model.matches[indexPath.row]
        model.wordFormatter.setLabelText(cell.textLabel, word)
        return cell
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
    // MARK: - MatchFoundObserver Conformance
    func matchFound()
    {
        //update UI on main thread
        DispatchQueue.main.async
        {
            self.matchesTable.reloadData()
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
            navBar.title = model.query
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
            matchesTable.reloadData()
            navBar.rightBarButtonItem?.isEnabled=true
        }
    }
    
}
