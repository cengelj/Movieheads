//
//  GenreViewController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 4/26/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit
import TMDBSwift

class GenreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var label: UILabel!
	var id:Int!
	var genre:String!
	var results = [MovieMDB]()
	var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
		label.text = genre
		for _ in 0..<100{
			images.append(UIImage())
		}
		collectionView.dataSource = self
		collectionView.delegate = self
		loadGenre()
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
	override var prefersStatusBarHidden: Bool{return true}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 80
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieImage", for: indexPath)
		cell.layer.borderWidth = 1.0
		cell.layer.borderColor = UIColor.black.cgColor
		let image = cell.viewWithTag(1) as! UIImageView
	
		image.image = images[indexPath.row]
		return cell
	}
	func loadGenre(){
		print("loading genre")
		for i in 0..<5{
			DiscoverMovieMDB.genreList(genreId: id, page: Double(i)) { [unowned self] (ret, movies) in
				if let m = movies{
					if i == 0{
						self.results = m
					}
					else{
						self.results.append(contentsOf: m)
					}
					self.loadMovies()
				}
			}
		}
	}
	func loadMovies(){
		let movies = results
		var count = 0
		loop: for movie in movies{
			if let path = movie.poster_path{
				if let param = URL(string:"https://image.tmdb.org/t/p/w92_and_h138_bestv2/\(path)"){
					loadPoster(param, index: count)
					if count == images.count-1{
						break loop
					}
				}
			}
			count += 1
		}
	}
	func loadPoster(_ URL: Foundation.URL, index:Int){
		DispatchQueue.global().async {
			let data = try? Data(contentsOf: URL)
			DispatchQueue.main.async {
				if let d = data{
					self.images[index] = UIImage(data:d)!
					
					self.collectionView.reloadItems(at: [IndexPath(row: index, section:0)])
				}
				if index==99{
					self.collectionView.reloadData()
				}
			}
		}
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "MoviePage", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!
		let sub = controller.childViewControllers[0] as! MovieController
		
		print(results.count)
		sub.movie = results[indexPath.row]
		topMostController().present(controller, animated: true, completion: nil)
	}
	func topMostController() -> UIViewController {
		var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
		while (topController.presentedViewController != nil) {
			topController = topController.presentedViewController!
		}
		return topController
	}
	@IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
		topMostController().dismiss(animated: true) {
		}
	}
}
