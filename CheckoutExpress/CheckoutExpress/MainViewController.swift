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
	var price: String
	var image: UIImage
}

class ItemTableViewCell: UITableViewCell{
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var itemImageView: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	func initialize(title: String, price: String, image: UIImage){
		self.titleLabel.text = title
		self.priceLabel.text = price
		self.itemImageView.image = image
	}
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var itemsTableView: UITableView!

	var items: [Item] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.itemsTableView.dataSource = self
		self.itemsTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("viewwillappear")
		self.itemsTableView.reloadData()
		print(items)
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("cellforrow")
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemTableViewCell
		let item = items[indexPath.row]
		cell?.initialize(title: item.name, price: item.price, image: item.image)
		
		
		return cell!
	}
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete{
			self.items.remove(at: indexPath.row)
			self.itemsTableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destVC = segue.destination as? BarcodeReaderViewController{
			destVC.items = self.items
		}
	}
}


