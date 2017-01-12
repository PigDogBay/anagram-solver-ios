//
//  TipViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 24/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class TipViewController: PageContentController
{
    let tip0 = ["Anagrams","Find words from jumbled letters\n\nEnter moonstarer\n\nTo find\n\nastronomer","moonstarer"]
    let tip1 = ["Blank Letters","Use + as a blank letter\n\nEnter scrabb++\n\nTo find\n\ncrabbers, scabbard...","scrabb++"]
    let tip2 = ["Two Words","Use a space to split the letters\n\nEnter james bond\n\nTo find\n\njabs demon and admen jobs","james bond"]
    let tip3 = ["Crosswords","Use dots for missing letters\n\nEnter m.g..\n\nTo find\n\nmagic, megan, mcgeee...","m.g.."]
    let tip4 = ["Shortcuts","Use numbers instead of dots\n\nEnter z9\n\nTo find\n\nzombielike, zookeepers","z9"]
    let tip5 = ["Supergrams","Find larger words\n\nEnter kayleigh*\n\nTo find\n\nbreathtakingly, heartbreakingly","kayleigh*"]
    let tip6 = ["Prefix@Suffix","Use @ for 1 or more letters\n\nEnter super@ted\n\nTo find\n\nsupersophisticated","super@ted"]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var query = "m.g.."

    @IBAction func showMeBtnPressed(_ sender: UIButton){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            if let navController = appDelegate.window?.rootViewController as? UINavigationController
            {
                if let viewController = navController.viewControllers[0] as? RootViewController
                {
                    viewController.showMe(query: query)
                }
            }
        }
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tip = getTip(pageIndex)
        titleLabel.text=tip[0]
        descriptionLabel.text = tip[1]
        query = tip[2]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Had a nightmare with swift multidimensioanl arrays, so using switch!!
    fileprivate func getTip(_ index : Int)->[String]
    {
        switch index
        {
        case 1:
            query = tip1[2]
            return tip1
        case 2:
            query = tip2[2]
            return tip2
        case 3:
            query = tip3[2]
            return tip3
        case 4:
            query = tip4[2]
            return tip4
        case 5:
            query = tip5[2]
            return tip5
        case 6:
            query = tip6[2]
            return tip6
        default:
            query = tip0[2]
            return tip0
        }
    }
    

}
