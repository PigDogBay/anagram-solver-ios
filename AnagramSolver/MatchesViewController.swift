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

    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var matchesTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func shareButton(_ sender: UIBarButtonItem)
    {
        let firstActivityItem = model.share()
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        //For iPads need to anchor the popover to the right bar button, crashes if not set
        if let ppc = activityViewController.popoverPresentationController {
            ppc.barButtonItem = navBar.rightBarButtonItem
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
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
            bannerView.load(GADRequest())
        }

        self.modelToView( model.appState.appState)
        model.appState.addObserver(observer: self)
        model.matches.setMatchesObserver(observer: self)
        
        if model.settings.isLongPressEnabled {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MatchesViewController.handleLongPress))
            matchesTable.addGestureRecognizer(longPress)
        }
    }
    @objc func handleLongPress(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.matchesTable)
            if let indexPath = matchesTable.indexPathForRow(at: touchPoint){
                if let word = model.getWord(atIndex: indexPath.row){
                    showLookUpDefinitionMenu(word: word, indexPath: indexPath)
                }
            }
        }
    }
    
    func shortenWord(word : String, maxSize : Int) -> String {
        if word.length <= maxSize {
            return word
        }
        return word[..<word.index(word.startIndex, offsetBy: maxSize)]+".."
    }
    
    func showLookUpDefinitionMenu(word : String, indexPath : IndexPath){
        let shortenedWord = shortenWord(word: word, maxSize: 12)
        let controller = UIAlertController(title: "Look up "+shortenedWord, message: nil, preferredStyle: .actionSheet)
        let googleAction = UIAlertAction(title: "Google Definition", style: .default,
                                         handler: {action in self.showDefinition(word: word, url: WordSearch.getGoogleUrl(word: word))})
        let collinsAction = UIAlertAction(title: "Collins", style: .default,
                                             handler: {action in self.showDefinition(word: word, url: WordSearch.getCollinsUrl(word: word))})
        let thesaurusAction = UIAlertAction(title: "Thesaurus", style: .default,
                                             handler: {action in self.showDefinition(word: word, url: WordSearch.getThesaurusUrl(word: word))})
        let wikipediaAction = UIAlertAction(title: "Wikipedia", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getWikipediaUrl(word: word))})
       
        let merriamWebsterAction = UIAlertAction(title: "Merriam-Webster", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getMerriamWebsterUrl(word: word))})
        let wordGameAction = UIAlertAction(title: "Word Game Dictionary", style: .default,
                                         handler: {action in self.showDefinition(word: word, url: WordSearch.getWordGameDictionaryUrl(word: word))})
        let oxfordAction = UIAlertAction(title: "Oxford Dictionaries", style: .default,
                                            handler: {action in self.showDefinition(word: word, url: WordSearch.getOxfordDictionariesUrl(word: word))})
        
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler: {action in UIPasteboard.general.string = word})
        let copyAllAction = UIAlertAction(title: "Copy All", style: .default, handler: {action in
            UIPasteboard.general.string = self.model.copyAll()})

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(googleAction)
        controller.addAction(merriamWebsterAction)
        controller.addAction(thesaurusAction)
        controller.addAction(collinsAction)
        controller.addAction(wordGameAction)
        controller.addAction(oxfordAction)
        controller.addAction(wikipediaAction)
        controller.addAction(copyAction)
        controller.addAction(copyAllAction)
        controller.addAction(cancelAction)

        //Anchor popover to button for iPads
        if let ppc = controller.popoverPresentationController{
            ppc.sourceView = self.tableView(matchesTable, cellForRowAt: indexPath)
        }
        present(controller, animated: true, completion: nil)
    }
    
    func showDefinition(word : String, url : String){
        self.selectedWord = word;
        self.wordDefinitionUrl = url;
        performSegue(withIdentifier: self.definitionSegueId, sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //Run worker thread here as if started in viewDidLoad
        //the ui may not be ready for when a match comes in
        if model.appState.isReady()
        {
            DispatchQueue.global(qos: .default).async
            {
                self.model.search()
            }
        }
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
            model.stop()
            model.appState.removeObserver(observer: self)
            model.matches.removeMatchObserver()
            Model.sharedInstance.ratings.requestRating()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
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
        DispatchQueue.main.sync
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
