//
//  Movie.swift
//  Movieheads
//
//  Created by Joseph Cengel (student LM) on 2/22/18.
//  Copyright © 2018 Joseph Cengel (student LM). All rights reserved.
//
//IMPORTANT....
/*
	Need to think about memory management. Can't cache too many movies at once.
	Maybe cache last 20 movies viewed?
	Throw out when the movie is closed.

	Also mobile data managment. Create setting for low data usage?
	Only grab information once, and close the connection immediately following. 
*/
import UIKit

class Movie{
	var name:String				//Movie name
	var info:[String:[String]]	//Basic movie metadata
	var released:String			//To-Do: change released to date object and convert in the init.
	var tagline:String
	var mpaa:Int				//MPAA Rating from 0-5. NR, G, PG, PG-13, R, NC-17. Expand for TV Movies?
	var image:UIImage?			//To-Do: Load seperately from online.
								//Consider using a singleton to grab the current category list.
	
	init(name:String="Unknown", tagline:String="Unknown", release:String="Unknown", mpaa:Int=0, info:[String:[String]]=[String:[String]]()){
		self.name = name
		self.info = info
		self.released = release
		self.tagline = tagline
		self.mpaa = mpaa
	}
}
