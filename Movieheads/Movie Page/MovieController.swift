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
	@IBOutlet weak var movieBanner: UIImageView!
	@IBOutlet weak var movieImage: UIImageView!
	@IBOutlet weak var ratings:UICollectionView!
	@IBOutlet weak var name:UILabel!
	@IBOutlet weak var mpaa: UIImageView!
	@IBOutlet weak var backButton: UIBarButtonItem!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var logo: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	weak var black = #imageLiteral(resourceName: "black")
	weak var white = #imageLiteral(resourceName: "white")
	var rotating = true
	
	var movie:MovieMDB!					// Set equal upon instantiation
	
	override func viewDidLoad() {
		super.viewDidLoad()
		activityIndicator.startAnimating()
		mpaa.alpha = 0
		name.alpha = 0
		ratings.alpha = 0
		collectionView.alpha = 0
		rotateView()
		let tap = UITapGestureRecognizer(target: self, action: #selector(MovieController.tapFunction(sender:)))
		name.isUserInteractionEnabled = true
		name.addGestureRecognizer(tap)
		var categories = [String]()
		var categoriesTotal = ["Humor", "Drama", "Visual Effects", "Writing", "Acting", "Action", "Horror", "Plot Complexity"]
		for genre in movie.genre_ids!{
			switch(getGenre(genre: genre)){
			case "Comedy":
				categories.append(categoriesTotal.remove(at: categoriesTotal.index(of: "Humor")!))
			case "Drama":
				categories.append(categoriesTotal.remove(at: categoriesTotal.index(of: "Drama")!))
			case "Science Fiction":
				if !categories.contains("Visual Effects"){
					categories.append(categoriesTotal.remove(at: categoriesTotal.index(of: "Visual Effects")!))
				}
			case "Animation":
				if !categories.contains("Visual Effects"){
					categories.append(categoriesTotal.remove(at: categoriesTotal.index(of: "Visual Effects")!))
				}
			case "Action":
				categories.append(categoriesTotal.remove(at: categoriesTotal.index(of: "Action")!))
			case "Horror":
				categories.append(categoriesTotal.remove(at: categoriesTotal.index(of: "Horror")!))
			case "Documentary":
				categoriesTotal.remove(at: categoriesTotal.index(of: "Writing")!)
				categoriesTotal.remove(at: categoriesTotal.index(of: "Acting")!)
				categoriesTotal.remove(at: categoriesTotal.index(of: "Plot Complexity")!)
			default:
				print("nothing")
			}
		}
		categories.reverse()
		for category in categories{
			categoriesTotal.insert(category, at: 0)
		}
		let DS = collectionView.dataSource as! MovieDataSource
		DS.categories = categoriesTotal
		print(categoriesTotal)
		
		setupView()
		print("loaded")
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
	func rotateView(){
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: { [unowned self] () -> Void in
			self.logo.transform = self.logo.transform.rotated(by: CGFloat(Double.pi / 2.0))
		}) { (finished) -> Void in
			if self.rotating{
				self.rotateView()
			}
		}
	}
	
	func setupView(){
		if let path = self.movie.poster_path{		//Asynchronous loading of images
			if let param = URL(string:"https://image.tmdb.org/t/p/w300_and_h450_bestv2/\(path)"){
				self.loadPoster(param)
			}
		}
		if let path = self.movie.backdrop_path{
			if let param = URL(string:"https://image.tmdb.org/t/p/w780/\(path)"){
				self.loadBanner(param)
			}
		}
		
		name.text = movie.title
		
		//Load MPAA rating from API
		let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movie.id!)/release_dates?api_key=\(APIKeys.shared.key)")!)
		URLSession.shared.dataTask(with: request){ [unowned self] data, response, error in
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
		print("Rating Loaded")
	}
	// Rating selection
	// To-Do: Set icons and make prettier.
	@IBAction func valueChanged(_ sender: UISegmentedControl) {
		var num = 0.0
		switch(sender.selectedSegmentIndex){
		case 0:
			num = 28.0
		case 1:
			num = 85.0
		case 2:
			num = 142.0
		default:
			print("oof")
		}
		for view in sender.subviews{
			if view.frame.midX == CGFloat(num){
				UIView.animate(withDuration: 0.5, animations: {
					view.alpha = 1.0
					view.tintColor = UIColor.red
				})
			}
			else{
				UIView.animate(withDuration: 0.5, animations: {
					view.alpha = 0.5
					view.tintColor = UIColor.lightGray
				})
			}
		}
	}
	func loadBanner(_ URL: Foundation.URL) {
		DispatchQueue.global().async {
			let data = try? Data(contentsOf: URL)
			if let d = data{
				// setting the actual image
				let image = UIImage(data:d)
				
				// Setting colors with their complements according to the image
				let mainColor = ColorThief.getColor(from: image!)?.makeUIColor()
				let pal = ColorThief.getPalette(from: image!, colorCount: 3)!
				let accColor = pal[0].makeUIColor().withAlphaComponent(0.5)
				let accColour = pal[1].makeUIColor().withAlphaComponent(0.2)
				print("Colors determined")
				DispatchQueue.main.async {
					self.ratings.backgroundColor = UIColor.clear
					//self.name.textColor = accColour.getComplement(color: accColour).withAlphaComponent(1.0)
					for view in self.ratings.subviews{
						if let rating = view as? UICollectionViewCell{
							rating.backgroundColor = accColor
							if let label = rating.viewWithTag(1) as? UILabel{
								label.textColor = accColor.getComplement(color: accColor)
								let attributes = [NSAttributedStringKey.strokeWidth: -0.5, NSAttributedStringKey.strokeColor : accColor, NSAttributedStringKey.foregroundColor:accColor.getComplement(color: accColor), NSAttributedStringKey.font : label.font] as [NSAttributedStringKey : Any]
								label.attributedText = NSAttributedString(string: label.text!, attributes: attributes)
							}
							else if let picker = rating.viewWithTag(2) as? UISegmentedControl{
								picker.backgroundColor = UIColor.clear
								picker.layer.borderWidth = 0.0
								// To-Do: Make it clear once we have icons.
								picker.tintColor = accColor.getComplement(color: accColor)
							}
						}
					}
					print("Colors set")
				}
				
				DispatchQueue.main.async {
					self.name.backgroundColor = accColour
					let attributes = [NSAttributedStringKey.strokeWidth: -0.5, NSAttributedStringKey.strokeColor : UIColor.black, NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font : self.name.font] as [NSAttributedStringKey : Any]
					self.name.attributedText = NSAttributedString(string: self.name.text!, attributes: attributes)
					self.name.layer.borderColor = UIColor.black.cgColor
					self.name.layer.borderWidth = 0.1
				}
				
				// Blurring the banner
				DispatchQueue.main.async {
					let cimage = CIImage(data:d)
					let blurredImage = cimage?.applyingGaussianBlur(sigma: 5.0)
					
					let croppedImage = blurredImage?.cropped(to: (cimage?.extent)!)
					self.movieBanner.alpha = 0
					
					self.movieBanner.image = UIImage(ciImage: (croppedImage)!)
					
					// Fade all objects back in
					UIView.animate(withDuration: 1.0, animations: {
						self.logo.alpha = 0
						self.navigationController?.navigationBar.barTintColor = mainColor
						self.backButton.tintColor = mainColor?.getComplement(color: mainColor!)
						self.movieBanner.alpha = 1
						self.movieImage.alpha = 1
						self.mpaa.alpha = 1
						self.name.alpha = 1
						self.collectionView.alpha = 1
						self.ratings.alpha = 1
						self.view.backgroundColor = mainColor?.colorWithBrightness(brightness: 2.5).withAlphaComponent(0.3)
						
					})
					self.rotating = false
					self.activityIndicator.stopAnimating()
					print("loaded")
				}
			}
		}
	}
	func loadPoster(_ URL: Foundation.URL) {
		DispatchQueue.global().async {
			let data = try? Data(contentsOf: URL)
			if let d = data{
				let image = UIImage(data: d)
				DispatchQueue.main.async {
					self.movieImage.alpha = 0
					self.movieImage.image = image
				}
			}
		}
	}
	@objc func tapFunction(sender:UITapGestureRecognizer) {
		
		let firstActivityItem = "\(String(describing: movie.original_title))"
		let secondActivityItem = URL(string: "https://www.themoviedb.org/movie/\(movie.id)")!
		
		let image = movieBanner.image!
		
		let activityViewController = UIActivityViewController(
			activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
		
		activityViewController.excludedActivityTypes =
			[UIActivityType.postToWeibo,
			 UIActivityType.addToReadingList,
			 UIActivityType.assignToContact,
			 UIActivityType.openInIBooks,
			 UIActivityType.postToFlickr,
			 UIActivityType.postToTencentWeibo,
			 UIActivityType.postToVimeo,
			 UIActivityType.print,
			 UIActivityType.markupAsPDF]
		
		self.present(activityViewController, animated: true, completion: nil)
	}
	func topMostController() -> UIViewController {
		var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
		while (topController.presentedViewController != nil) {
			topController = topController.presentedViewController!
		}
		return topController
	}
	func getGenre(genre:Int) -> String{
		var genreID = ""
		switch(genre){
		case 28:
			genreID = "Action"
		case 12:
			genreID = "Adventure"
		case 16:
			genreID = "Animation"
		case 35:
			genreID = "Comedy"
		case 80:
			genreID = "Crime"
		case 99:
			genreID = "Documentary"
		case 18:
			genreID = "Drama"
		case 10751:
			genreID = "Family"
		case 14:
			genreID = "Fantasy"
		case 36:
			genreID = "History"
		case 27:
			genreID = "Horror"
		case 10402:
			genreID = "Music"
		case 9648:
			genreID = "Mystery"
		case 10749:
			genreID = "Romance"
		case 878:
			genreID = "Science Fiction"
		case 10770:
			genreID = "TV Movie"
		case 53:
			genreID = "Thriller"
		case 10752:
			genreID = "War"
		case 37:
			genreID = "Western"
		default:
			genreID = ""
		}
		return genreID
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


