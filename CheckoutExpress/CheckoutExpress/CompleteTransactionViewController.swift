//
//  CompleteTransactionViewController.swift
//  CheckoutExpress
//
//  Created by Sang Hyuk Cho on 11/6/16.
//  Copyright © 2016 ce. All rights reserved.
//

import UIKit

class CompleteTransactionViewController: UIViewController {

	@IBOutlet weak var subtotalLabel: UILabel!{
		didSet{
			subtotalLabel.textAlignment = .right
		}
	}
	@IBOutlet weak var taxLabel: UILabel!{
		didSet{
			taxLabel.textAlignment = .right
		}
	}
	@IBOutlet weak var totalLabel: UILabel!{
		didSet{
			totalLabel.textAlignment = .right
		}
	}
	@IBOutlet weak var doneButton: UIButton!{
		didSet{
			doneButton.setTitle("DONE", for: .normal)
			doneButton.setTitleColor(UIColor.white, for: .normal)
			doneButton.backgroundColor = UIColor.black
		}
	}
	
	var subtotal: Double = 0{
		willSet{
			self.subtotalLabel.text = "$ " + Utility.formatPrice(price: newValue)
		}
	}
	var tax: Double = 0{
		willSet{
			self.taxLabel.text = "$ " + Utility.formatPrice(price: newValue)
		}
	}
	var total: Double = 0{
		willSet{
			self.totalLabel.text = "$ " + Utility.formatPrice(price: newValue)
		}
	}
	
	var items: [Item] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		self.updateTotals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func updateTotals(){
		var tmpSubtotal: Double = 0
		for item in items{
			tmpSubtotal += item.price
		}
		self.subtotal = tmpSubtotal
		self.tax = tmpSubtotal * 0.06
		self.total = self.subtotal + self.tax
	}

}
