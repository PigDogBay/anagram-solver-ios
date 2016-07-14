//
//  TipsPageViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 24/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class TipsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    private let tipsCount = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource=self
        let startView = viewControllerAtIndex(0)
        self.setViewControllers([startView], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getSearchAction()->String
    {
        let tipsVC = self.viewControllers![0] as! TipViewController
        return tipsVC.query
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageContentVC = viewController as! PageContentController
        var index = pageContentVC.pageIndex
        if index == 0{
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let pageContentVC = viewController as! PageContentController
        var index = pageContentVC.pageIndex
        if index == NSNotFound{
            return nil
        }
        index += 1
        if index==tipsCount
        {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    private func viewControllerAtIndex(index: Int) -> PageContentController!
    {
        if index >= tipsCount
        {
            return nil
        }
        var pageContentVC : PageContentController!
        if !Model.sharedInstance.isProMode && index == (tipsCount-1)
        {
            pageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("HelpOutViewController") as! PageContentController
        }
        else
        {
            pageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("TipViewController") as! PageContentController
        }
        pageContentVC.pageIndex = index
        return pageContentVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tipsCount
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }


}
