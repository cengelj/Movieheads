//
//  MovieDataSource.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/22/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class MovieDataSource: NSObject, UICollectionViewDataSource{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell:UICollectionViewCell
		if(indexPath.row%2==0){
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath)
		}
		else{
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Rating", for: indexPath)
		}
		cell.layer.borderWidth = 0.5
		cell.layer.borderColor = UIColor.lightGray.cgColor
		
		return cell
	}
}
