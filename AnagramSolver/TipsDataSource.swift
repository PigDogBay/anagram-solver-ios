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
    static let tip0 = ["Anagrams","Find words from jumbled letters\n\nEnter moonstarer\n\nTo find\n\nastronomer","moonstarer"]
    static let tip1 = ["Blank Letters","Use + as a blank letter\n\nEnter scrabb++\n\nTo find\n\ncrabbers, scabbard...","scrabb++"]
    static let tip2 = ["Two Words","Use a space to split the letters\n\nEnter james bond\n\nTo find\n\njabs demon and admen jobs","james bond"]
    static let tip3 = ["Crosswords","Use dots for missing letters\n\nEnter m.g..\n\nTo find\n\nmagic, megan, mcgeee...","m.g.."]
    static let tip4 = ["Shortcuts","Use numbers instead of dots\n\nEnter z9\n\nTo find\n\nzombielike, zookeepers","z9"]
    static let tip5 = ["Supergrams","Find larger words\n\nEnter kayleigh*\n\nTo find\n\nbreathtakingly, heartbreakingly","kayleigh*"]
    static let tip6 = ["Prefix@Suffix","Use @ for 1 or more letters\n\nEnter super@ted\n\nTo find\n\nsupersophisticated","super@ted"]
    static let tips = [tip0,tip1,tip2,tip3,tip4,tip5,tip6]
    
    let tipCellId = "cellBulb"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellId, for: indexPath)
        if let tipCell = cell as? TipCollectionViewCell {
            tipCell.titleLabel.text = TipsDataSource.tips[indexPath.row][0]
            tipCell.descriptionLabel.text = TipsDataSource.tips[indexPath.row][1]
        }
        return cell
    }

}
