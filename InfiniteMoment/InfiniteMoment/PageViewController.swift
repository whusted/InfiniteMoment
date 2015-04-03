//
//  PageViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/2/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 0
    var identifiers: NSArray = ["FeedViewController", "CreationViewController", "FriendsListController"]

    
    override func viewDidLoad() {

        self.dataSource = self
        self.delegate = self
        
        
        let startingViewController = viewControllerAtIndex(self.index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        println(self.index)
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //first view controller = firstViewControllers navigation controller
        if index == 0 {
            println("At first one")
            return storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as UIViewController
            
        }
        
        //second view controller = secondViewController's navigation controller
        if index == 1 {
            println("At second one")
            return storyboard.instantiateViewControllerWithIdentifier("CreationViewController") as UIViewController
        }
        
        if index == 2 {
            println("At third one")
            return storyboard.instantiateViewControllerWithIdentifier("FriendsListController") as UIViewController
        }
        
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = self.index + 1
        return self.viewControllerAtIndex(self.index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = self.index - 1
        return self.viewControllerAtIndex(self.index)
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }
    
}