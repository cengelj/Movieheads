//
//  FirstTimeController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 4/4/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class FirstTimeController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	var pages = [UIViewController]()
	override func viewDidLoad() {
        super.viewDidLoad()
		self.dataSource = self
		self.delegate = self
		
		pages = [self.getViewController(withIdentifier: "genre"), self.getViewController(withIdentifier: "share"), self.getViewController(withIdentifier: "rating"), self.getViewController(withIdentifier: "enter")]
		if let first = pages.first{
			setViewControllers([first], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
		}
		let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
		appearance.pageIndicatorTintColor = UIColor.blue
		appearance.currentPageIndicatorTintColor = UIColor.cyan
		appearance.backgroundColor = UIColor.clear
		appearance.tintColor = UIColor.clear
		self.view.backgroundColor = UIColor.clear
		//Check if first time setup
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let index = pages.index(of: viewController)! - 1
		if index >= 0 {
			return pages[index]
		}
		else{
			return nil
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let index = pages.index(of: viewController)! + 1
		if index < pages.count {
			usleep(30)
			return pages[index]
		}
		else{
			finished()
			return nil
		}
	}
	func finished(){
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!
		
		self.present(controller, animated: true, completion: nil)
	}
	func getViewController(withIdentifier identifier: String) -> UIViewController{
		return UIStoryboard(name: "FirstTime", bundle: nil).instantiateViewController(withIdentifier: identifier)
	}
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return pages.count
	}
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		guard let firstViewController = viewControllers?.first,
			let firstViewControllerIndex = pages.index(of: firstViewController) else {
				return 0
		}
		
		return firstViewControllerIndex
	}

}
