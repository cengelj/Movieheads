//
//  MovieDataSource.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/22/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit
import Pods_Movieheads
import TMDBSwift

class MovieDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate{
	var categories:[String] = ["Comedy", "Plot Complexity", "Violence", "Acting", "Dialogue", "Other", "Other"]
	var movie:MovieMDB!
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count*2
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell:UICollectionViewCell
		if(indexPath.row%2==0){
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath)
			let label = cell.viewWithTag(1) as! UILabel
			label.text = categories[indexPath.row/2]
		}
		else{
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Rating", for: indexPath)
			
			let label = collectionView.cellForItem(at: IndexPath(item: indexPath.row-1, section: 0))?.viewWithTag(1) as! UILabel
			
			let _ = #imageLiteral(resourceName: "horror").withRenderingMode(.alwaysOriginal)
			let picker = cell.viewWithTag(2) as! UISegmentedControl
			let normalFont = UIFont(name: "Helvetica", size: 30.0)
			
			picker.setTitleTextAttributes([NSAttributedStringKey.font: normalFont], for: .normal)
				for i in 0..<3{
					switch(label.text!){
					case "Humor":
						picker.setTitle("😂", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Drama":
						picker.setTitle("😭", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Writing":
						picker.setTitle("✏️", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Acting":
						picker.setTitle("🎭", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Visual Effects":
						picker.setTitle("👀", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Action":
						picker.setTitle("💥", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Plot Complexity":
						picker.setTitle("🤔", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					case "Horror":
						picker.setTitle("😱", forSegmentAt: i)
						if i==0{
							picker.removeBorders()
						}
					default:
						print("Incorrect Genre")
					}
				}
			
			picker.layer.borderWidth = 0.0
			
			let savedRatings = UserDefaults.standard.dictionary(forKey: "ratings") as! [String:[Double]]
			let userRatings = UserDefaults.standard.dictionary(forKey: "userRatings") as! [String:Int]
			let index = String(describing:"\(movie.id!).\(indexPath.row/2)")
			if let r = userRatings[index]{
				picker.selectedSegmentIndex = r
				
				var num = 0.0
				switch(r){
				case 0:
					num = 28.0
				case 1:
					num = 85.0
				case 2:
					num = 142.0
				default:
					print("oof")
				}
				for view in picker.subviews{
					if view.frame.midX == CGFloat(num){
						UIView.animate(withDuration: 0.5, animations: {
							view.alpha = 1.0
							view.tintColor = UIColor.red
						})
					}
					else if view.frame.midX < CGFloat(num){
						UIView.animate(withDuration: 0.5, animations: {
							view.alpha = 0.5
							view.tintColor = UIColor.lightGray
						})
					}
					else{
						UIView.animate(withDuration: 0.5, animations: {
							view.alpha = 0.2
							view.tintColor = UIColor.lightGray
						})
					}
				}
			}
			else if let r = savedRatings[index]{
				let x = round(r[0])
				picker.selectedSegmentIndex = Int(x)
				
				var num = 0.0
				switch(Int(x)){
				case 0:
					num = 28.0
				case 1:
					num = 85.0
				case 2:
					num = 142.0
				default:
					print("oof")
				}
				for view in picker.subviews{
					if view.frame.midX == CGFloat(num){
						UIView.animate(withDuration: 0.5, animations: {
							view.alpha = 0.7
							view.tintColor = UIColor.red
						})
					}
					else if view.frame.midX < CGFloat(num){
						UIView.animate(withDuration: 0.5, animations: {
							view.alpha = 0.3
							view.tintColor = UIColor.lightGray
						})
					}
					else{
						UIView.animate(withDuration: 0.5, animations: {
							view.alpha = 0.1
							view.tintColor = UIColor.lightGray
						})
					}
				}
			}
		}
		cell.layer.borderWidth = 1.0
		cell.layer.borderColor = UIColor.black.cgColor
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row%2 == 0{
			let name = categories[indexPath.row/2]
			print(collectionView.frame.minY)
			//let rect = CGRect(x: collectionView.bounds.midX-150.0, y: (collectionView.superview?.bounds.midY)!, width: 0.0, height: 0.0)
			let rect = CGRect(x: collectionView.bounds.midX-150.0, y: collectionView.frame.minY+(CGFloat(indexPath.row/2))*62.5, width: 0.0, height: 0.0)
			let textView = UITextView(frame: rect)
			let tap = UITapGestureRecognizer(target: self, action: #selector(MovieDataSource.tapFunction(sender:)))
			textView.addGestureRecognizer(tap)
			textView.isUserInteractionEnabled = true
			
			textView.contentMode = .center
			textView.textAlignment = .center
			collectionView.superview?.addSubview(textView)
			
			UIView.animate(withDuration: 0.5, animations: {
				textView.frame = CGRect(x: collectionView.bounds.midX-150.0, y: collectionView.frame.minY+(CGFloat(indexPath.row/2))*62.5, width: 300.0, height: 100.0)
				
					//CGRect(x: collectionView.bounds.midX-150.0, y: (collectionView.superview?.bounds.midY)!, width: 300.0, height: 100.0)
			})
			UIView.animate(withDuration: 0.2, animations: {
				textView.layer.cornerRadius = 10.0
				textView.clipsToBounds = true
			})
			UIView.animate(withDuration: 0.5, animations: {
				switch(name){
				case "Humor":
					textView.text = "Humor Debug Description"
				case "Drama":
					textView.text = "Drama Debug Description"
				case "Visual Effects":
					textView.text = "Visual Effects Debug Description"
				case "Writing":
					textView.text = "Writing Debug Description"
				case "Acting":
					textView.text = "Acting Debug Description"
				case "Action":
					textView.text = "Action Debug Description"
				case "Horror":
					textView.text = "Horror Debug Description"
				case "Plot Complexity":
					textView.text = "Plot Complexity Debug Description"
				default:
					print("This isn't supposed to happen")
				}
			})
		}
	}
	@objc func tapFunction(sender:UITapGestureRecognizer) {
		UIView.animate(withDuration: 0.5, animations: {
			let textView = sender.view as! UITextView
			textView.frame = CGRect(x: textView.frame.minX, y: textView.frame.minY, width: 0.0, height: 0.0)
		}) { (boo) in
			sender.view?.removeFromSuperview()
		}
	}
}
extension UISegmentedControl {
	func removeBorders() {
		setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
		setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
		setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
	}
	private func imageWithColor(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image!
	}
}
