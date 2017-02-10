//
//  IntroViewController.swift
//  NotifyMe
//
//  Created by Pierre on 1/24/17.
//  Copyright © 2017 Pierre. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

	//MARK: IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true 
    }
    
    //MARK: Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
    }
}

extension IntroViewController: IntroPageControlDelegate {
    
    func introPageViewControllerCount(introPageViewController: IntroPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        
    }
    
    func pageViewControllerIndex(introPageViewController: IntroPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
