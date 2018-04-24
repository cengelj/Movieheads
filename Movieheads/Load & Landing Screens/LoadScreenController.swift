//
//  ViewController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/14/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

// might deprecate

import UIKit

class LoadScreenController: UIViewController {

	@IBOutlet weak var logo: UIImageView!
	override func viewDidLoad() {
		super.viewDidLoad()
		rotateView()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override var prefersStatusBarHidden: Bool{return true}
	func rotateView(){
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: { [unowned self] () -> Void in
			self.logo.transform = self.logo.transform.rotated(by: CGFloat(Double.pi / 2.0))
		}) { (finished) -> Void in
			self.rotateView()
		}
	}
}

