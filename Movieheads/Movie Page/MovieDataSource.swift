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

class MovieDataSource: NSObject, UICollectionViewDataSource{
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
		}
		cell.layer.borderWidth = 1.0
		cell.layer.borderColor = UIColor.black.cgColor
		
		return cell
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
