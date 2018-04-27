//
//  LandingScreen.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

// no spaghet

import UIKit
import Pods_Movieheads
import TMDBSwift

class LandingScreenController: UIViewController, UICollectionViewDelegate {
	@IBOutlet weak var collectionView: UICollectionView!
	var genres:[String] = ["Action", "Horror", "Drama", "Comedy"]
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let layout = collectionView?.collectionViewLayout as? CollectionLayout {
			layout.delegate = self
		}
		let source = collectionView.dataSource as! DiscoverDataSource
		self.genres.sort()
		source.genres = self.genres
		
		TMDBConfig.apikey = APIKeys.shared.key
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override var prefersStatusBarHidden: Bool{return true}

	@IBAction func toSearch(_ sender: UIBarButtonItem) {
		let storyboard = UIStoryboard(name: "Search", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!
		
		self.present(controller, animated: true, completion: nil)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row%2==0{
			let cell = collectionView.cellForItem(at: indexPath)
			let label = cell?.viewWithTag(1) as! UILabel
			
			let storyboard = UIStoryboard(name: "Genre", bundle: nil)
			let controller = storyboard.instantiateInitialViewController()!
			let sub = controller.childViewControllers[0] as! GenreViewController
			sub.id = convert(label.text!)
			sub.genre = label.text!
			
			topMostController().present(controller, animated: true, completion:nil)
		}
	}
	func convert(_ genre:String) -> Int{
		var genreID = 0
		switch(genre){
		case "Action":
			genreID = 28
		case "Adventure":
			genreID = 12
		case "Animation":
			genreID = 16
		case "Comedy":
			genreID = 35
		case "Crime":
			genreID = 80
		case "Documentary":
			genreID = 99
		case "Drama":
			genreID = 18
		case "Family":
			genreID = 10751
		case "Fantasy":
			genreID = 14
		case "History":
			genreID = 36
		case "Horror":
			genreID = 27
		case "Music":
			genreID = 10402
		case "Mystery":
			genreID = 9648
		case "Romance":
			genreID = 10749
		case "Science Fiction":
			genreID = 878
		case "TV Movie":
			genreID = 10770
		case "Thriller":
			genreID = 53
		case "War":
			genreID = 10752
		case "Western":
			genreID = 37
		default:
			genreID = 0
		}
		return genreID
	}
	func topMostController() -> UIViewController {
		var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
		while (topController.presentedViewController != nil) {
			topController = topController.presentedViewController!
		}
		return topController
	}
	
	
}
