//
//  CollectionLayout.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 3/20/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewLayout {
	weak var delegate:LandingScreenController!
	fileprivate var numberOfColumns = 1
	fileprivate var cellPadding: CGFloat = 2.0
	fileprivate var cache = [UICollectionViewLayoutAttributes]()
	fileprivate var contentHeight: CGFloat = 0
	fileprivate var contentWidth: CGFloat {
		guard let collectionView = collectionView else {
			return 0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	override func prepare() {
		guard cache.isEmpty == true, let collectionView = collectionView else {
			return
		}
		for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
			let indexPath = IndexPath(item: item, section: 0)
			var frame = CGRect()
			if item%2==0{
				frame = CGRect(origin: CGPoint(x: 0, y: getValue(indexPath.row)), size: CGSize(width: UIScreen.main.bounds.width, height: 50.0))
			}
			else{
				frame = CGRect(origin: CGPoint(x: 0, y: getValue(indexPath.row)), size: CGSize(width: UIScreen.main.bounds.width, height: 138.0))
			}
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = frame
			cache.append(attributes)
			contentHeight = max(contentHeight, frame.maxY)
		}
	}
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
		
		for attributes in cache {
			if attributes.frame.intersects(rect) {
				visibleLayoutAttributes.append(attributes)
			}
		}
		return visibleLayoutAttributes
	}
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath.item]
	}
	func getValue(_ input:Int) -> Int{
		switch(input){
			case 0:
				return 25-25
			case 1:
				return 95-25-20-20+10+10
			case 2:
				return 240-25-20-20+10
			case 3:
				return 310-25-40-20-20+10+10
			case 4:
				return 455-25-40-20-20+10
			case 5:
				return 525-25-60-20-20-20+10+10
			case 6:
				return 670-25-60-20-20-20+10
			case 7:
				return 740-25-80-20-20-20-20+10+10
			case 8:
				return 885-25-80-20-20-20-20+10
			case 9:
				return 955-25-100-20-20-20-20-20+10+10
			default:
				return 0
		}
	}
	
	
}
