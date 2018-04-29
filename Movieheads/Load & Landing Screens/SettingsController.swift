//
//  SettingsController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 4/9/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

// no spaghet

import UIKit

class SettingsController: UIViewController {
	@IBOutlet weak var button: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		button.layer.cornerRadius = 10
		button.clipsToBounds = true
		
		// Setting up the gradient
		let layer = CAGradientLayer()
		layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		layer.colors = [UIColor.darkGray.cgColor, UIColor.gray.cgColor]
		view.layer.insertSublayer(layer, at: 0)
		navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override var prefersStatusBarHidden: Bool{return true}
    
	@IBAction func buttonPressed(_ sender: UIButton) {
		
		let alert = UIAlertController(title: "Data Reset", message: "Are you sure you want to reset the app data? This cannot be undone.", preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
			UserDefaults.standard.removeObject(forKey: "genres")
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		
		self.present(alert, animated: true)
	}

}
