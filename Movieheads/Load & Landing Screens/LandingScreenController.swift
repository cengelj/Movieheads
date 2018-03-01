//
//  LandingScreen.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class LandingScreenController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func toSearch(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "Search", bundle: nil)
		
		let controller = storyboard.instantiateInitialViewController()!
		//storyboard.instantiateViewController(withIdentifier: "InitialController") as! SearchController
		self.present(controller, animated: true, completion: nil)
		
	}
	@IBAction func toMovie(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "MoviePage", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!
		//storyboard.instantiateViewController(withIdentifier: "Movie Controller") as! MovieController
		self.present(controller, animated: true, completion: nil)
	}
	@IBAction func toLoad(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!
		//storyboard.instantiateViewController(withIdentifier: "Load Screen Controller") as! LoadScreenController
		self.present(controller, animated: true, completion: nil)
	}
	
	
}
