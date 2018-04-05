//
//  GenreController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 4/5/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class GenreController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	@IBOutlet weak var collectionView: UICollectionView!
	let genres:[String] = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "History", "Horror", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]
	var selectedGenres = [String]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		self.navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return genres.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genre", for: indexPath)
		let label = cell.viewWithTag(1) as! UILabel
		label.text = genres[indexPath.row]
		cell.backgroundColor = UIColor.blue
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		let genre = genres[indexPath.row]
		cell?.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
		
		if selectedGenres.contains(genre){
			print(genres[indexPath.row], " deselected")
			selectedGenres.remove(at: selectedGenres.index(of: genre)!)
			cell?.backgroundColor = UIColor.blue
		}
		else{
			if selectedGenres.count >= 4{
				let rem = selectedGenres.remove(at: 0)
				collectionView.cellForItem(at: IndexPath(row: genres.index(of: rem)!, section: 0))?.backgroundColor = UIColor.blue
				
			}
			selectedGenres.append(genre)
		}
		
	}
}
