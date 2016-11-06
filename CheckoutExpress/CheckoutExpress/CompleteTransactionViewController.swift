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
	
	var subtotal: Double = 0
	var tax: Double = 0
	var total: Double = 0
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		self.subtotalLabel.text = "$ " + String(round(100*subtotal)/100)
		self.taxLabel.text = "$ " + String(round(100*tax)/100)
		self.totalLabel.text = "$ " + String(round(100*total)/100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
