//
//  IntroPageViewController.swift
//  NotifyMe
//
//  Created by Pierre on 1/24/17.
//  Copyright © 2017 Pierre. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    //MARK: Properties
	var pages = [UIViewController]()
    
    weak var pageControlDelgate: IntroPageControlDelegate?
    

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
		dataSource = self
        delegate = self
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intro_Page_1")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intro_Page_2")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intro_Page_3")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([page1], direction: .forward, animated: true, completion: nil)
        
        pageControlDelgate?.introPageViewControllerCount(introPageViewController: self, didUpdatePageCount: pages.count)
    }
    
    
    //MARK: Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: Delegate Functions
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController) {
            if index > 0 {
                return pages[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController) {
            if index < pages.count - 1 {
                return pages[index + 1]
            } else {
                return nil
            }
        }
        
        return nil
    }

    
}

protocol IntroPageControlDelegate: class {
	
    func introPageViewControllerCount(introPageViewController: IntroPageViewController, didUpdatePageCount count: Int)
    
    func pageViewControllerIndex(introPageViewController: IntroPageViewController, didUpdatePageIndex index: Int)
    
}


