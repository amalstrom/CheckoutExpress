//
//  MainViewController.swift
//  CheckoutExpress
//
//  Created by Sang Hyuk Cho on 11/3/16.
//  Copyright © 2016 ce. All rights reserved.
//

import UIKit

struct Item{
	let name: String
	let price: Double
	var quantity: Int
	var totalPrice: Double{
		get{
			return price * Double(quantity)
		}
	}
	let image: UIImage
	
	init(name: String, price: Double, imageURL: String){
		self.name = name
		self.price = price
		self.quantity = 1
		do{
			try self.image = UIImage(data: Data(contentsOf: URL(string: imageURL)!))!
		}
		catch{
			print("error")
			self.image = UIImage()
		}
	}
	func getPrice() -> String{
		return String(describing: price)
	}
	func getQuantity() -> String{
		return String(quantity)
	}
}





class ItemTableViewCell: UITableViewCell{
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var itemImageView: UIImageView!
	@IBOutlet weak var quantityLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var subtractButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	func updateValues(item: Item){
		self.titleLabel.text = item.name
		self.priceLabel.text = "$ " + String(item.price)
		self.quantityLabel.text = String(item.quantity)
		self.itemImageView.image = item.image
	}
	func updateQuantity(quantity: Int){
		self.quantityLabel.text = String(quantity)
	}
	func updatePrice(price: Double){
		self.priceLabel.text = String(price)
	}
}





class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var addItemButton: UIButton!
	@IBOutlet weak var checkoutButton: UIButton!
	@IBOutlet weak var totalPriceLabel: UILabel!
	
	@IBOutlet weak var itemsTableView: UITableView!

	var items: [Item] = []
	var total: Double = 0.0{
		willSet{
			self.totalPriceLabel.text = "Total: $ " + Utility.formatPrice(price: newValue)
		}
	}
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.itemsTableView.reloadData()
		self.updateTotal()
	}
	
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
	
	
	
	
	// UITableView Delegate methods
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemTableViewCell
		let item = items[indexPath.row]
		cell?.updateValues(item: item)
		cell?.addButton.tag = indexPath.row
		cell?.subtractButton.tag = indexPath.row
		cell?.addButton.addTarget(self, action: #selector(MainViewController.incQuantity(sender:)), for: .touchUpInside)
		cell?.subtractButton.addTarget(self, action: #selector(MainViewController.decQuantity(sender:)), for: .touchUpInside)
		return cell!
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete{
			self.items.remove(at: indexPath.row)
			self.itemsTableView.deleteRows(at: [indexPath], with: .automatic)
			self.updateTotal()
		}
	}
	
	
	
	
	func updateTotal(){
		var newTotal: Double = 0
		for item in self.items{
			newTotal += item.price
		}
		self.total = newTotal
	}
	func incQuantity(sender: UIButton){
		self.items[sender.tag].quantity += 1
		self.total += self.items[sender.tag].price
		let cell = self.itemsTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ItemTableViewCell
		cell?.updateQuantity(quantity: self.items[sender.tag].quantity)
	}
	func decQuantity(sender: UIButton){
		if 0 < self.items[sender.tag].quantity{
			self.items[sender.tag].quantity -= 1
			self.total -= self.items[sender.tag].price
			let cell = self.itemsTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ItemTableViewCell
			cell?.updateQuantity(quantity: self.items[sender.tag].quantity)
		}
	}
	
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "MoveToBarcode"{
			if let destVC = segue.destination as? BarcodeReaderViewController{
				destVC.items = self.items
			}
		}
		else{
			if let destVC = segue.destination as? CompleteTransactionViewController{
				destVC.items = self.items
			}
		}
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if  identifier == "MoveToCheckout"{
			if self.items.count == 0{
				return false
			}
			else{
				return true
			}
		}
		else{
			return true
		}
	}
	@IBAction func unwind(sender: UIStoryboardSegue){}
}


