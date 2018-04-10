//
//  SettingsController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 4/9/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
	let gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
		let layer = CAGradientLayer()
		layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		layer.colors = [UIColor.darkGray.cgColor, UIColor.gray.cgColor]
		view.layer.addSublayer(layer)
		navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override var prefersStatusBarHidden: Bool{return true}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
