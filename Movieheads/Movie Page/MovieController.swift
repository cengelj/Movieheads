//
//  MovieController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class MovieController: UIViewController {
	@IBOutlet var movieBanner: UIImageView!
	@IBOutlet var movieImage: UIImageView!
	@IBOutlet var ratings:UICollectionView!
	@IBOutlet var search:UISearchBar!
	@IBOutlet var name:UITextView!
	@IBOutlet var mpaa:UITextView!
	
	var movie:Movie!			// Will be set equal to the movie w/prepareforsegue
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func setupView(){
		if let i = movie.image{movieImage.image = i}		// Later load asynchronously
		if let b = movie.banner{movieBanner.image = b}
		mpaa.text = movie.mpaa
		name.text = movie.name
		
	}
	@IBAction func valueChanged(_ sender: UISegmentedControl) {
		
	}
}
