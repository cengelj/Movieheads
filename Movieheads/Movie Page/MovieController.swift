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
import ColorThiefSwift

class MovieController: UIViewController {
	@IBOutlet var movieBanner: UIImageView!
	@IBOutlet var movieImage: UIImageView!
	@IBOutlet var ratings:UICollectionView!
	@IBOutlet var name:UILabel!
	@IBOutlet weak var mpaa: UIImageView!
	@IBOutlet weak var backButton: UIBarButtonItem!
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
	@IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
		topMostController().dismiss(animated: true) {
			// Cache info here?
		}
	}
	
	func setupView(){
		if let path = movie.poster_path{		//Asynchronous loading of images
			if let param = URL(string:"https://image.tmdb.org/t/p/w300_and_h450_bestv2/\(path)"){
				loadPoster(param)
			}
		}
		if let path = movie.backdrop_path{
			if let param = URL(string:"https://image.tmdb.org/t/p/w780/\(path)"){
				loadBanner(param)
		}
		
		}
		
		let blur = UIBlurEffect(style: UIBlurEffectStyle.prominent)	//Add blur to movie banner
		let blurEffectView = UIVisualEffectView(effect: blur)
		blurEffectView.alpha = 0.4
		
		blurEffectView.frame = movieBanner.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		movieBanner.addSubview(blurEffectView)
		
		
		movieBanner.tintColor = UIColor.black
		name.text = movie.title
		
		//Load MPAA rating from API
		let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movie.id!)/release_dates?api_key=\(APIKeys.shared.key)")!)
		URLSession.shared.dataTask(with: request){ data, response, error in
			if let jsonData = data,
				let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary{
				let results = feed.value(forKey: "results") as! NSArray
				if results.count > 0{
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
				else{
					self.setMPAA(string: "UR")
				}
			}
			}.resume()
		
	}
	//Set images for MPAA, as well as aspect ratios and size
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
	// Rating selection
	// To-Do: Set icons and make prettier. 
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
		DispatchQueue.global().async {
			let data = try? Data(contentsOf: URL)
			DispatchQueue.main.async {
				if let d = data{
					// setting the actual image
					self.movieBanner.image = UIImage(data: d)
					
					// Setting colors with their complements according to the image
					var mainColor = ColorThief.getColor(from: UIImage(data:d)!)?.makeUIColor()
					let pal = ColorThief.getPalette(from: self.movieBanner.image!, colorCount: 3)!
					let accColor = pal[0].makeUIColor().withAlphaComponent(0.5)
					let accColour = pal[1].makeUIColor().withAlphaComponent(0.2)
					
					self.name.backgroundColor = accColour
					let attributes = [NSAttributedStringKey.strokeWidth: -2.0, NSAttributedStringKey.strokeColor : UIColor.black, NSAttributedStringKey.foregroundColor:accColor.getComplement(color: accColour.getComplement(color: accColour).withAlphaComponent(1.0)), NSAttributedStringKey.font : self.name.font] as [NSAttributedStringKey : Any]
					self.name.attributedText = NSAttributedString(string: self.name.text!, attributes: attributes)
					self.name.layer.borderColor = UIColor.black.cgColor
					self.name.layer.borderWidth = 0.1
					
					
					self.navigationController?.navigationBar.barTintColor = mainColor
					self.backButton.tintColor = mainColor?.getComplement(color: mainColor!)
					
					mainColor = mainColor?.colorWithBrightness(brightness: 2.5).withAlphaComponent(0.3)
					self.view.backgroundColor = mainColor
					self.ratings.backgroundColor = UIColor.clear
					self.name.textColor = accColour.getComplement(color: accColour).withAlphaComponent(1.0)
					
					for view in self.ratings.subviews{
						if let rating = view as? UICollectionViewCell{
							rating.backgroundColor = accColor
							if let label = rating.viewWithTag(1) as? UILabel{
								label.textColor = accColor.getComplement(color: accColor)
								let attributes = [NSAttributedStringKey.strokeWidth: -1.0, NSAttributedStringKey.strokeColor : UIColor.black, NSAttributedStringKey.foregroundColor:accColor.getComplement(color: accColor), NSAttributedStringKey.font : label.font] as [NSAttributedStringKey : Any]
								label.attributedText = NSAttributedString(string: label.text!, attributes: attributes)
							}
							else if let picker = rating.viewWithTag(2) as? UISegmentedControl{
								picker.backgroundColor = UIColor.clear
								picker.layer.borderWidth = 0.0
								picker.tintColor = accColor.getComplement(color: accColor)
							}
						}
					}
					
					self.view.reloadInputViews()
				}
			}
		}
	}
	func loadPoster(_ URL: Foundation.URL) {
		DispatchQueue.global().async {
			let data = try? Data(contentsOf: URL)
			DispatchQueue.main.async {
				if let d = data{
					self.movieImage.image = UIImage(data: d)
				}
			}
		}
	}
	func topMostController() -> UIViewController {
		var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
		while (topController.presentedViewController != nil) {
			topController = topController.presentedViewController!
		}
		return topController
	}
}

public extension UIColor {
	public func colorWithBrightness(brightness: CGFloat) -> UIColor {
		var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
		
		if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
			B += (brightness - 1.0)
			B = max(min(B, 1.0), 0.0)
			
			return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
		}
		
		return self
	}
	public func getComplement(color: UIColor) -> UIColor {
		
		let ciColor = CIColor(color: color)
		
		// get the current values and make the difference from white:
		let compRed: CGFloat = 1.0 - ciColor.red
		let compGreen: CGFloat = 1.0 - ciColor.green
		let compBlue: CGFloat = 1.0 - ciColor.blue
		
		return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
	}
}
