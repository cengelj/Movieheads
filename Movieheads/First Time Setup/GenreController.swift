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
		collectionView.backgroundColor = UIColor.clear
		
		let layer = CAGradientLayer()
		layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		layer.colors = [UIColor.green.withAlphaComponent(0.1).cgColor, UIColor.cyan.cgColor]
		view.layer.insertSublayer(layer, at: 0)
		
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
		cell.layer.cornerRadius = 10
		cell.clipsToBounds = true
		
		let label = cell.viewWithTag(1) as! UILabel
		label.text = genres[indexPath.row]
		cell.backgroundColor = UIColor.red.withAlphaComponent(0.05)
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)!
		let genre = genres[indexPath.row]
		
		let layer = CAGradientLayer()
		layer.frame = CGRect(x: cell.bounds.minX, y: cell.bounds.minY, width: (cell.bounds.width), height: (cell.bounds.height))
		layer.colors = [UIColor.red.withAlphaComponent(0.2).cgColor, UIColor.red]
		cell.layer.insertSublayer(layer, at: 0)
		
		if selectedGenres.contains(genre){
			print(genres[indexPath.row], " deselected")
			selectedGenres.remove(at: selectedGenres.index(of: genre)!)
			
			for lay in cell.layer.sublayers!{
				if let l = lay as? CAGradientLayer{
					l.removeFromSuperlayer()
				}
			}
		}
		else{
			if selectedGenres.count >= 4{
				let rem = selectedGenres.remove(at: 0)
				for lay in (collectionView.cellForItem(at: IndexPath(row: genres.index(of: rem)!, section: 0))?.layer.sublayers)!{
					if let l = lay as? CAGradientLayer{
						l.removeFromSuperlayer()
					}
				}
			}
			selectedGenres.append(genre)
		}
		
	}
}
