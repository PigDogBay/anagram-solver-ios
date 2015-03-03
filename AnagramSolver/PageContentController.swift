//
//  PageContentController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/03/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class PageContentController: UIViewController
{
    var pageIndex : Int = 0
    @IBAction func backgroundTap(sender: AnyObject)
    {
        //dismiss the keyboard
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }

}
