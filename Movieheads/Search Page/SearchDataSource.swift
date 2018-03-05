//
//  SearchDataSource.swift
//  Movieheads
//
//  Created by Justin Wootton (student LM) on 2/28/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit
import Pods_Movieheads
import TMDBSwift

class SearchDataSource: NSObject, UITableViewDataSource {
	var results = [MovieMDB]()
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return results.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell:UITableViewCell
		cell = tableView.dequeueReusableCell(withIdentifier: "Listing")!
		let label = cell.viewWithTag(1) as! UILabel
		let date = results[indexPath.row].release_date!.prefix(4)
		label.text = "\(String(describing: results[indexPath.row].title!)) (\(date))"
		
		return cell
	}
	// To-Do: Limit user to 1 search every 10 seconds?
	func filter(searchText: String, tableView: UITableView){
		// Load Movie Names From API
		SearchMDB.movie(query: searchText, language: "en", page: 1, includeAdult: true, year: nil, primaryReleaseYear: nil) { (data, m) in
			if let movies = m{
				self.set(movies: movies)
				tableView.reloadData()
			}
		}
	}
	func set(movies:[MovieMDB]){
		results = movies
	}
	func getResult(index:Int) -> MovieMDB{
		return results[index]
	}
}
