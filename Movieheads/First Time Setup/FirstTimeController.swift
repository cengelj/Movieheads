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
	var genreController:GenreController!
	override func viewDidLoad() {
        super.viewDidLoad()
		if let array = UserDefaults.standard.array(forKey: "genres") as? [String] {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateInitialViewController()!
			let sub = controller.childViewControllers[0] as! LandingScreenController
			
			sub.genres = array
			self.present(controller, animated: true, completion: nil)
		}
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
		
		self.navigationController?.hidesBarsOnTap = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	override var prefersStatusBarHidden: Bool{return true}
	
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
		if index - 1 == 0{
			let vc = viewController as! GenreController
			genreController = vc
			if vc.selectedGenres.count == 0{
				let alert = UIAlertController(title: "Genre Selection", message: "You haven't selected any genres, four default genres will be used if you don't select some. This can be changed in the settings", preferredStyle: .alert)
				
				alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
				
				self.present(alert, animated: true)
				viewController.view.reloadInputViews()
				return pages[index]
			}
			else if vc.selectedGenres.count < 3 {
				var word = "genres"
				if vc.selectedGenres.count == 1{
					word = "genre"
				}
				let alert = UIAlertController(title: "Genre Selection", message: "You have only selected \(vc.selectedGenres.count) \(word). You can select up to four genres to display on the home screen.", preferredStyle: .alert)
				
				alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
				
				self.present(alert, animated: true)
				viewController.view.reloadInputViews()
				return pages[index]
			}
			else{
				genreController = vc
			}
		}
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
		let sub = controller.childViewControllers[0] as! LandingScreenController
		
		if !genreController.selectedGenres.isEmpty{
			sub.genres = genreController.selectedGenres
			UserDefaults.standard.set(genreController.selectedGenres, forKey: "genres")
		}
		else{
			UserDefaults.standard.set(sub.genres, forKey: "genres")
		}
		UserDefaults.standard.synchronize()
		
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
