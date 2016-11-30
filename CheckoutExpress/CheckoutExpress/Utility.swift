//
//  Utility.swift
//  CheckoutExpress
//
//  Created by Sang Hyuk Cho on 11/30/16.
//  Copyright © 2016 ce. All rights reserved.
//

import Foundation

class Utility{
	static func formatPrice(price: Double) -> String{
		return String(round(100*price)/100)
	}
}
