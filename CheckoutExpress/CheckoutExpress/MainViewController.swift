//
//  MainViewController.swift
//  CheckoutExpress
//
//  Created by Sang Hyuk Cho on 11/3/16.
//  Copyright © 2016 ce. All rights reserved.
//

import UIKit

struct Item{
	var name: String
	var price: CGFloat
	var quantity: Int
}

class ItemTableViewCell: UITableViewCell{
	@IBOutlet weak var quantityLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var itemImageView: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var itemsTableView: UITableView!

	var items: [Item]?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (items?.count)!
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as? ItemTableViewCell
		return cell!
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
