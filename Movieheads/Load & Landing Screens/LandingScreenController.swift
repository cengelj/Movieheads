//
//  LandingScreen.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit
import Pods_Movieheads
import TMDBSwift

class LandingScreenController: UIViewController, UICollectionViewDelegate {
	@IBOutlet weak var collectionView: UICollectionView!
	var genres:[String]!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let layout = collectionView?.collectionViewLayout as? CollectionLayout {
			layout.delegate = self
		}
		let source = collectionView.dataSource as! DiscoverDataSource
		source.genres = self.genres
		
		TMDBConfig.apikey = APIKeys.shared.key
		print("loaded")
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
	
	
}
