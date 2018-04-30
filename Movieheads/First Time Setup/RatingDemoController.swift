//
//  RatingDemoController.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 4/30/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class RatingDemoController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var badLabel: UILabel!
	@IBOutlet weak var badIcon: UILabel!
	@IBOutlet weak var middleIcon: UILabel!
	@IBOutlet weak var goodIcon: UILabel!
	@IBOutlet weak var goodLabel: UILabel!
	@IBOutlet var instructions: [UILabel]!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewDidAppear(_ animated: Bool) {
		beginAnimations()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	func beginAnimations(){
		UIView.animate(withDuration: 0.5, animations: {
			self.titleLabel.alpha = 1.0
			self.badIcon.alpha = 0.5
			self.goodIcon.alpha = 0.5
			self.middleIcon.alpha = 0.5
		}) { (b) in
			self.animateBad()
		}
	}
	func animateBad(){
		UIView.animate(withDuration: 1.5, animations: {
			self.badIcon.alpha = 1.0
			self.badLabel.alpha = 1.0
			self.badLabel.transform = self.badLabel.transform.scaledBy(x: 1.2, y: 1.2)
		}) { (b) in
			UIView.animate(withDuration: 0.5, animations: {
				self.badLabel.transform = self.badLabel.transform.scaledBy(x: 0.8, y: 0.8)
				self.badLabel.alpha = 0.2
				self.badIcon.alpha = 0.5
			}, completion: { (bo) in
				self.animateGood()
			})
		}
	}
	func animateGood(){
		UIView.animate(withDuration: 1.5, animations: {
			self.goodIcon.alpha = 1.0
			self.goodLabel.alpha = 1.0
			self.goodLabel.transform = self.goodLabel.transform.scaledBy(x: 1.2, y: 1.2)
		}) { (b) in
			UIView.animate(withDuration: 0.5, animations: {
				self.goodLabel.transform = self.goodLabel.transform.scaledBy(x: 0.8, y: 0.8)
				self.goodLabel.alpha = 0.2
				self.goodIcon.alpha = 0.5
			}, completion: { (bo) in
				self.animateInstructions()
			})
		}
	}
	func animateInstructions(_ i:Int=0){
		UIView.animate(withDuration: 1.0, animations: {
			self.instructions[i].alpha = 1.0
		}) { (b) in
			if i < 3{
				self.animateInstructions(i+1)
			}
		}
	}

}
