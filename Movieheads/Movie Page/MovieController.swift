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
	@IBOutlet weak var mpaa: UIImageView!
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
		name.text = movie.title
		let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movie.id!)/release_dates?api_key=\(APIKeys.shared.key)")!)
		URLSession.shared.dataTask(with: request){ data, response, error in
			if let jsonData = data,
				let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary{
				let results = feed.value(forKey: "results") as! NSArray
				loop: for i in (0...results.count-1).reversed(){
					let dict = results[i] as! NSDictionary
					let country = dict.value(forKey: "iso_3166_1") as! NSString
					if country == "US"{
						let outer = dict.value(forKey: "release_dates") as! NSArray
						let inner = outer[0] as! NSDictionary
						let str = inner.value(forKey: "certification") as? String
						DispatchQueue.main.async {						//Run it on the main thread as per swift guidelines
							if let s = str {
								if s == ""{self.setMPAA(string: "UR")}
								else{self.setMPAA(string: s)}
							}
							else{self.setMPAA(string: "UR")}
						}
						
						break loop
					}
				}
				
			}
			}.resume()
		
	}
	func setMPAA(string:String){
		switch(string){
			case "G":
				mpaa.image = #imageLiteral(resourceName: "MPAA_G")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 40.0, height: 40.0))
			case "PG":
				mpaa.image = #imageLiteral(resourceName: "MPAA_PG")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 0.5333333333, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 75.0, height: 40.0))
			case "NR":
				mpaa.image = #imageLiteral(resourceName: "MPAA_NR")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 0.5333333333, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 75.0, height: 40.0))
			case "UR":
				mpaa.image = #imageLiteral(resourceName: "MPAA_UR")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 0.5333333333, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 75.0, height: 40.0))
			case "PG-13":
				mpaa.image = #imageLiteral(resourceName: "MPAA_PG13")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 0.2857142857, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 141.0, height: 40.0))
			case "NC-17":
				mpaa.image = #imageLiteral(resourceName: "MPAA_NC17")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 0.2857142857, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 141.0, height: 40.0))
			case "R":
				mpaa.image = #imageLiteral(resourceName: "MPAA_R")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 40.0, height: 40.0))
			default:
				mpaa.image = #imageLiteral(resourceName: "MPAA_NR")
				mpaa.addConstraint(NSLayoutConstraint(item: mpaa, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: mpaa, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
				mpaa.frame = CGRect(origin: mpaa.frame.origin, size: CGSize(width: 40.0, height: 40.0))
		}
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
