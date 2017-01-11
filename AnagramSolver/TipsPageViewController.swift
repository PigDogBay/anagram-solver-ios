//
//  TipsPageViewController.swift
//  ProtoTypeUI
//
//  Created by Mark Bailey on 24/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

class TipsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    fileprivate let tipsCount = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource=self
        let startView = viewControllerAtIndex(0)
        self.setViewControllers([startView!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageContentVC = viewController as! PageContentController
        var index = pageContentVC.pageIndex
        if index == 0{
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> PageContentController!
    {
        if index >= tipsCount
        {
            return nil
        }
        let pageContentVC : PageContentController! = self.storyboard?.instantiateViewController(withIdentifier: "TipViewController") as! PageContentController
        pageContentVC.pageIndex = index
        return pageContentVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return tipsCount
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }


}
