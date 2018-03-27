//
//  DiscoverPageDataSource.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 3/15/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit
import Pods_Movieheads
import TMDBSwift

class DiscoverDataSource: NSObject, UICollectionViewDataSource{
	var genres:[String] = ["Action", "Horror", "Drama", "Comedy", "Science Fiction"]
	var results = ["String":[MovieMDB]()]
	let resultCount = 20
	var images = [[UIImage]]()
	var collectionViews = [UICollectionView]()
	
	override init(){
		super.init()
		for number in 0..<genres.count{
			images.append([UIImage]())
			for i in 0..<20{
				images[number].append(UIImage())
			}
		}
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView.tag==0{
			return genres.count*2
		}
		else{
			return 20
		}
		
	}
	func convertToNum(_ string:String) -> Int{
		var genreID = 0
		switch(string){
			case "Action":
				genreID = 0
			case "Horror":
				genreID = 1
			case "Drama":
				genreID = 2
			case "Comedy":
				genreID = 3
			case "Science Fiction":
				genreID = 4
			default:
				genreID = 0
		}
		return genreID
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell:UICollectionViewCell
		if collectionView.tag == 0{
			if(indexPath.row%2 == 0){
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath)
				let label = cell.viewWithTag(1) as! UILabel
				label.text = genres[indexPath.row/2]
			}
			else{
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieImages", for: indexPath)
				
				let label = cell.viewWithTag(2) as! UILabel
				label.text = genres[indexPath.row/2]
				loadGenre(genre:genres[indexPath.row/2])
				
				if collectionViews.count < genres.count{
					let cv = cell.viewWithTag(1) as! UICollectionView
					cv.bounds = CGRect(origin: cv.bounds.origin, size: CGSize(width:UIScreen.main.bounds.width, height: cv.bounds.height))
					print(cv.bounds.origin)
					collectionViews.append(cv)
				}
			}
			cell.layer.borderWidth = 0.5
			cell.layer.borderColor = UIColor.lightGray.cgColor
			
			return cell
		}
		else {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieImage", for: indexPath)
			cell.layer.borderWidth = 0.0
			let label = collectionView.viewWithTag(2) as! UILabel
			let image = cell.viewWithTag(1) as! UIImageView
			
			let value = label.text!
			image.image = images[convertToNum(value)][indexPath.row]
			//images[convertToNum(value)].append(image)
			
			return cell
		}
		
	}
	
	func loadGenre(genre:String){
		var genreID = 0
		switch(genre){
		case "Action":
			genreID = 28
		case "Adventure":
			genreID = 12
		case "Animation":
			genreID = 16
		case "Comedy":
			genreID = 35
		case "Crime":
			genreID = 80
		case "Documentary":
			genreID = 99
		case "Drama":
			genreID = 18
		case "Family":
			genreID = 10751
		case "Fantasy":
			genreID = 14
		case "History":
			genreID = 36
		case "Horror":
			genreID = 27
		case "Music":
			genreID = 10402
		case "Mystery":
			genreID = 9648
		case "Romance":
			genreID = 10749
		case "Science Fiction":
			genreID = 878
		case "TV Movie":
			genreID = 10770
		case "Thriller":
			genreID = 53
		case "War":
			genreID = 10752
		case "Western":
			genreID = 37
		default:
			genreID = 0
		}
		//to-do: error handling
		GenresMDB.genre_movies(genreId: genreID, include_adult_movies: true, language: "en") { (res, movies) in
			if let m = movies{
				self.results[genre] = m
				self.loadMovies(genre:genre)
			}
		}
	}
	func loadMovies(genre:String){
		let movies = results[genre]
		var count = 0
		loop: for movie in movies!{
			if let path = movie.poster_path{
				if let param = URL(string:"https://image.tmdb.org/t/p/w92_and_h138_bestv2/\(path)"){
					loadPoster(param, genre, count)
					if count == images[convertToNum(genre)].count-1{
						break loop
					}
				}
			}
			count += 1
		}
	}
	
	func loadPoster(_ URL: Foundation.URL, _ genre: String, _ index:Int){
		let request = URLRequest(url: URL)
//		NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
//			if let imageData = data {
//				self.images[self.convertToNum(genre)][index] = UIImage(data:imageData)!
//				if index==19{
//					print(genre, " Loaded")
//					self.collectionViews[self.convertToNum(genre)].reloadData()
//				}
//			}
//		}
		
				DispatchQueue.global().async {
					let data = try? Data(contentsOf: URL)
					DispatchQueue.main.async {
						if let d = data{
							self.images[self.convertToNum(genre)][index] = UIImage(data:d)!
						}
						if index==19{
							print(genre, " Loaded")
							self.collectionViews[self.convertToNum(genre)].reloadData()
						}
					}
				}
				
			}
	
}
