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
		}
		cell.layer.borderWidth = 1.0
		cell.layer.borderColor = UIColor.black.cgColor
		
		return cell
	}
}
