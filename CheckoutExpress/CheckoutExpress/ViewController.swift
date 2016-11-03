//
//  ViewController.swift
//  CheckoutExpress
//
//  Created by Sang Hyuk Cho on 10/31/16.
//  Copyright © 2016 ce. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
//		let request = NSMutableURLRequest(URL: NSURL(string: "http://api.walmartlabs.com/v1/items")!)
//		request.HTTPMethod = "POST"
//		let postString = "apiKey=yfahd49q5ahmbr5wjv4arrk8&upc=035000521019"
//		request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
//			guard error == nil && data != nil else {                                                          // check for fundamental networking error
//				print("error=\(error)")
//				return
//			}
//			
//			if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//				print("statusCode should be 200, but is \(httpStatus.statusCode)")
//				print("response = \(response)")
//			}
//			
//			let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
//			print("responseString = \(responseString)")
//		}
//		task.resume()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

