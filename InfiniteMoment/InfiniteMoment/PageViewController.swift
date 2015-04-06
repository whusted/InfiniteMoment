//
//  PageViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/2/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import Foundation
import UIKit

var index = 0

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var identifiers: NSArray = ["MomentsFeedNavigationController", "TextCreationNavigationController", "FriendsListNavigationController"]

    
    override func viewDidLoad() {

        self.dataSource = self
        self.delegate = self
        
        
        let startingViewController = viewControllerAtIndex(index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
    }
    
    func viewControllerAtIndex(index: Int) -> UINavigationController! {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if index == 0 {
            return storyboard.instantiateViewControllerWithIdentifier("MomentsFeedNavigationController") as UINavigationController
            
        }
        
        if index == 1 {
            return storyboard.instantiateViewControllerWithIdentifier("TextCreationNavigationController") as UINavigationController
        }
        
        if index == 2 {
            return storyboard.instantiateViewControllerWithIdentifier("FriendsListNavigationController") as UINavigationController
        }
        
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        println("Id in after: \(identifier)")
        let current_index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if current_index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        index = index + 1
        println("index after: \(index)")
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        println("Id in before: \(identifier)")
        let current_index = self.identifiers.indexOfObject(identifier!)
        println("index from id in before: \(index)")
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if current_index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        index = index - 1
        println("index before: \(index)")
        return self.viewControllerAtIndex(index)
        
    }
    
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
//        return self.identifiers.count
//    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }
    
}