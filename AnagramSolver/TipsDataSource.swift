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
    static let tip1 = ["Blank Letters","Use + as a blank letter\nEnter scrabb++\nTo find\ncrabbers, scabbard...","scrabb++"]
    static let tip2 = ["Two Words","Use a space to split the letters\nEnter james bond\nTo find\njabs demon and admen jobs","james bond"]
    static let tip3 = ["Crosswords","Use dots for missing letters\nEnter m.g..\nTo find\nmagic, megan, mcgeee...","m.g.."]
    static let tip4 = ["Shortcuts","Use numbers instead of dots\nEnter z9\nTo find\nzombielike, zookeepers","z9"]
    static let tip5 = ["Supergrams","Find larger words\nEnter kayleigh*\nTo find\nbreathtakingly, heartbreakingly","kayleigh*"]
    static let tip6 = ["Prefix@Suffix","Use @ for 1 or more letters\nEnter super@ted\nTo find\nsupersophisticated","super@ted"]
    static let tips = [tip0,tip1,tip2,tip3,tip4,tip5,tip6]
    
    let tipCellId = "cellBulb"
    var showMeCallback : ((_ query : String) -> Void)?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellId, for: indexPath)
        if let tipCell = cell as? TipCollectionViewCell {
            tipCell.setDescription(string: TipsDataSource.tips[indexPath.row][1])
            tipCell.titleLabel.text = TipsDataSource.tips[indexPath.row][0]
            tipCell.query = TipsDataSource.tips[indexPath.row][2]
            tipCell.showMeCallback = self.showMeCallback
        }
        //https://stackoverflow.com/questions/18113872/uicollectionviewcell-with-rounded-corners-and-drop-shadow-not-working
        cell.layer.cornerRadius = 6.0
//Shadow effect
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        cell.layer.shadowRadius = 2.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }

}
