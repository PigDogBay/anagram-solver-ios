//
//  TipViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 24/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class TipViewController: UIViewController
{
    
    let tip0 : [String] = ["Anagrams","Find words from jumbled letters\n\nEnter persia\n\nTo find\n\naspire, praise...","persia"]
    let tip1 : [String] = ["Crossword Clues","Use dots for missing letters\n\nEnter m.g..\n\nTo find\n\nmagic, megan, mcgeee...","m.g.."]
    let tip2 = ["Sub Anagrams","Find words within words\n\nEnter goldmine\n\nTo find\n\nmolding, golden, gnome...","goldmine"]
    let tip3 = ["Look Up Words","Press the info icon\n\nnext to a word\n\nto look up it's meaning","definition"]
    let tip4 = ["Two Word Anagrams","Use a space to split the letters\n\nEnter manchester united\n\nTo find\n\nfunny names","manchester united"]
    let tip5 = ["Shortcuts","Use numbers instead of dots\n\nEnter z9\n\nTo find\n\nzombielike, zookeepers","z9"]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBAction func backgroundTap(sender: AnyObject)
    {
        //dismiss the keyboard
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }

    var pageIndex : Int = 0
    var query = "m.g.."

    override func viewDidLoad()
    {
        super.viewDidLoad()
        println("TipsVC \(pageIndex) loaded")
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
    private func getTip(index : Int)->[String]
    {
        switch index
        {
        case 1:
            return tip1
        case 2:
            return tip2
        case 3:
            return tip3
        case 4:
            return tip4
        case 5:
            return tip5
        default:
            return tip0
        }
    }
    

}
