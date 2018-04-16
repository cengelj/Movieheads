//
//  MovieDataSource.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/22/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class MovieDataSource: NSObject, UICollectionViewDataSource{
	let categories:[String] = ["Comedy", "Plot Complexity", "Violence", "Acting", "Dialogue", "Other", "Other"]
	
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
			let picker = cell.viewWithTag(2) as! UISegmentedControl
			let horror = #imageLiteral(resourceName: "horror").withRenderingMode(.alwaysOriginal)
			let action = #imageLiteral(resourceName: "action").withRenderingMode(.alwaysOriginal)
			let visual = #imageLiteral(resourceName: "visualfx").withRenderingMode(.alwaysOriginal)
			let other = #imageLiteral(resourceName: "Image").withRenderingMode(.alwaysOriginal)
			for i in 0..<5{
				switch(indexPath.row){
					case 1:
						picker.setImage(horror, forSegmentAt: i)
					case 3:
						picker.setImage(action, forSegmentAt: i)
					case 5:
						picker.setImage(visual, forSegmentAt: i)
					default:
						picker.setImage(other, forSegmentAt: i)
					}
			}
		}
		cell.layer.borderWidth = 1.0
		cell.layer.borderColor = UIColor.black.cgColor
		
		return cell
	}
}
