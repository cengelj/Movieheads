//
//   SearchController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//
import UIKit
import TMDBSwift
import Pods_Movieheads

class SearchController: UIViewController, UITableViewDelegate, UISearchBarDelegate{
	@IBOutlet var tableView: UITableView!
	var searchDataSource = SearchDataSource()
	let searchController = UISearchController(searchResultsController: nil)
	var results = [MovieMDB]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let _ = tableView {		// To prevent accidental crashing while juggling view controllers
			tableView.dataSource = searchDataSource
			searchController.searchBar.delegate = self
			searchController.dimsBackgroundDuringPresentation = false
			definesPresentationContext = true
			tableView.tableHeaderView = searchController.searchBar
			searchController.searchBar.barTintColor = UIColor.darkGray
			tableView.backgroundColor = UIColor.darkGray
			UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], for: .normal)
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	@IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
		topMostController().dismiss(animated: true) {
			// Do any disassembly or whatever
		}
	}
	override var prefersStatusBarHidden: Bool{return true}
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
		searchDataSource.filter(searchText: searchBar.text!, tableView: tableView)
	}
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		results = [MovieMDB]()
	}
	func tableView(_ table: UITableView, didSelectRowAt: IndexPath){
		let res = table.dataSource as! SearchDataSource
		
		let storyboard = UIStoryboard(name: "MoviePage", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!// as! MovieController
		let sub = controller.childViewControllers[0] as! MovieController
		sub.movie = res.results[didSelectRowAt.row]
		
		topMostController().present(controller, animated: true, completion: nil)
		
	}
	func topMostController() -> UIViewController {
		var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
		while (topController.presentedViewController != nil) {
			topController = topController.presentedViewController!
		}
		return topController
	}
	
	
}
