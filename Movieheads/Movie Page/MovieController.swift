//
//  MovieController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit
import Pods_Movieheads
import TMDBSwift

class MovieController: UIViewController {
	@IBOutlet var movieBanner: UIImageView!
	@IBOutlet var movieImage: UIImageView!
	@IBOutlet var ratings:UICollectionView!
	@IBOutlet var name:UITextView!
	@IBOutlet var mpaa:UITextView!
	var black = #imageLiteral(resourceName: "black")
	var white = #imageLiteral(resourceName: "white")
	
	
	var movie:MovieMDB!					// Set equal upon instanciation
	
	override func viewDidLoad() {

		super.viewDidLoad()
		setupView()
		// Do any additional setup after loading the view, typically from a nib.
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override var prefersStatusBarHidden: Bool{return true}
	func setupView(){
		//if let i = movie.image{movieImage.image = i}		// Later load asynchronously
		if let path = movie.poster_path{
			if let param = URL(string:"https://image.tmdb.org/t/p/w300_and_h450_bestv2/\(path)"){
				loadPoster(param)
			}
		}
		if let path = movie.backdrop_path{
			if let param = URL(string:"https://image.tmdb.org/t/p/w780/\(path)"){
				loadBanner(param)
		}
		
		}
		
		let blur = UIBlurEffect(style: UIBlurEffectStyle.prominent)
		let blurEffectView = UIVisualEffectView(effect: blur)
		blurEffectView.alpha = 0.4
		
		blurEffectView.frame = movieBanner.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		movieBanner.addSubview(blurEffectView)
		
		
		movieBanner.tintColor = UIColor.black
		mpaa.text = "PG-13"	//Temp
		name.text = movie.title
		
	}
	@IBAction func valueChanged(_ sender: UISegmentedControl) {
		for i in 0...sender.selectedSegmentIndex{
			sender.setTitle("X", forSegmentAt: i)
		}
		if sender.selectedSegmentIndex+1 <= sender.numberOfSegments-1{
			for i in sender.selectedSegmentIndex+1...sender.numberOfSegments-1{
				sender.setTitle("O", forSegmentAt: i)
			}
		}
	}
	func loadBanner(_ URL: Foundation.URL) {
		let request = URLRequest(url: URL)
		NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
			if let imageData = data {
				self.movieBanner.image = UIImage(data: imageData)
			}
		}
	}
	func loadPoster(_ URL: Foundation.URL) {
		let request = URLRequest(url: URL)
		NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
			if let imageData = data {
				self.movieImage.image = UIImage(data: imageData)
			}
		}
	}
}
