//
//  TipsDataSource.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 08/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import UIKit

class TipsDataSource : NSObject, UICollectionViewDataSource
{
    static let tip0 = ["Anagrams","Find words from jumbled letters\nEnter moonstarer\nTo find\nastronomer","moonstarer"]
    static let tip1 = ["Crossw.rds","Use dots for unknown letters\nEnter m.g..\nTo find\nmagic, megan, mcgeee...","m.g.."]
    static let tip2 = ["Two Words","Use a space to split the letters\nEnter james bond\nTo find\njabs demon and admen jobs","james bond"]
    static let tip3 = ["Blank Letters","Use + as a blank letter\nEnter scrabb++\nTo find\ncrabbers, scabbard...","scrabb++"]
    static let tip4 = ["Shortcuts","Use numbers for multiple unknowns\nEnter z9 instead of z.........\nTo find\nzombielike, zookeepers","z9"]
    static let tip5 = ["Supergrams","Find larger words\nEnter kayleigh*\nTo find\nbreathtakingly, heartbreakingly","kayleigh*"]
    static let tip6 = ["Prefix@Suffix","Use @ for 1 or more letters\nEnter super@ted\nTo find\nsupersophisticated","super@ted"]
    static let tip7 = ["Codewords","Use 1,2,3 to represent\nthe same letters.\nTry ..112332\nFor cassette, pallette...","..112332"]
    static let tips = [tip0,tip1,tip2,tip3,tip4,tip5,tip6,tip7]
    
    let tipCellId = "cellBulb"
    var showMeCallback : ((_ query : String) -> Void)?
    var rateCallback : (() -> Void)?
    var feedbackCallback : (() -> Void)?
    var recommendCallback : (() -> Void)?
    var viewGuideCallback : (() -> Void)?
    var settingsCallback : (() -> Void)?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell!
        switch indexPath.row {
        case 0:
            //Anagrams
            cell = getTipCell(tipIndex: 0, collectionView: collectionView, indexPath: indexPath)
        case 1:
            //Blank Letters
            cell = getTipCell(tipIndex: 1, collectionView: collectionView, indexPath: indexPath)
        case 2:
            //Definitions
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDefinitions", for: indexPath)
        case 3:
            //Crosswords
            cell = getTipCell(tipIndex: 3, collectionView: collectionView, indexPath: indexPath)
        case 4:
            //Filters
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFilters", for: indexPath)
        case 5:
            //Two Words
            cell = getTipCell(tipIndex: 2, collectionView: collectionView, indexPath: indexPath)
        case 6:
            //Settings
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSettings", for: indexPath)
            if let actionCell = cell as? ActionCollectionViewCell {
                actionCell.button1Callback = self.settingsCallback
            }
        case 7:
            //Short cuts
            cell = getTipCell(tipIndex: 4, collectionView: collectionView, indexPath: indexPath)
        case 8:
            //User Guide
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellUserGuide", for: indexPath)
            if let actionCell = cell as? ActionCollectionViewCell {
                actionCell.button1Callback = self.viewGuideCallback
            }
        case 9:
            //Supergrams
            cell = getTipCell(tipIndex: 5, collectionView: collectionView, indexPath: indexPath)
        case 10:
            //Help Out
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHelpOut", for: indexPath)
            if let actionCell = cell as? ActionCollectionViewCell {
                actionCell.button1Callback = self.feedbackCallback
                actionCell.button2Callback = self.rateCallback
                actionCell.button3Callback = self.recommendCallback
            }
        case 11:
            //Prefix@Suffix
            cell = getTipCell(tipIndex: 6, collectionView: collectionView, indexPath: indexPath)
        case 12:
            cell = getTipCell(tipIndex: 7, collectionView: collectionView, indexPath: indexPath)
        default:
            abort()
        }
        return cell
    }
    
    func getTipCell(tipIndex : Int, collectionView: UICollectionView, indexPath : IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellId, for: indexPath)
        if let tipCell = cell as? TipCollectionViewCell {
            tipCell.setDescription(string: TipsDataSource.tips[tipIndex][1])
            tipCell.titleLabel.text = TipsDataSource.tips[tipIndex][0]
            tipCell.query = TipsDataSource.tips[tipIndex][2]
            tipCell.showMeCallback = self.showMeCallback
        }
        return cell
    }

}
