//
//  BarcodeReaderViewController.swift
//  CheckoutExpress
//
//  Created by Sang Hyuk Cho on 11/2/16.
//  Copyright © 2016 ce. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	var captureSession: AVCaptureSession?
	var previewLayer: AVCaptureVideoPreviewLayer?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.setupCapture()
    }
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		if (captureSession?.running == false) {
			captureSession?.startRunning()
		}
	}
 
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		if (captureSession?.running == true) {
			captureSession?.stopRunning()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func setupCapture(){
		// Set the captureDevice to currently running device
		let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		// Object for receiving inputs from captureDevice
		let videoInput: AVCaptureDeviceInput?
		// If input from the captureDevice is available, initialize
		do{
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		}
		catch{
			return
		}
		
		// If there is an input to be added to the captureSession, add it
		// Same for adding output to the captureSession
		if let captureSession = self.captureSession{
			if (captureSession.canAddInput(videoInput)) {
				captureSession.addInput(videoInput)
			} else {
				self.alertScanNotAvailable()
			}
			
			// Object to be processed by a delegate object
			let captureMetadataOutput = AVCaptureMetadataOutput()
			
			if(captureSession.canAddOutput(captureMetadataOutput)){
				// Add captured data to the captureSession
				captureSession.addOutput(captureMetadataOutput)
				// Send captured data to the delegate object via a serial queue
				captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
				// Set barcode type to: EAN-13
				captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
			}
			
			if (captureSession.canAddOutput(captureMetadataOutput)) {
				captureSession.addOutput(captureMetadataOutput)
				
				// Send captured data to the delegate object via a serial queue.
				captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
				
				// Set barcode type for which to scan: EAN-13.
				// Note: EAN-13 is UPC-A with 0 added in the beginning
				captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
				
			} else {
				self.alertScanNotAvailable()
			}
			
			// Add previewLayer and have it show the video data
			self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
			self.previewLayer?.frame = self.view.layer.bounds
			self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
			if let previewLayer = self.previewLayer{
				self.view.layer.addSublayer(previewLayer)
			}
			// Begin the capture session
			self.captureSession?.startRunning()
		}
		
	}
	
	func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
		
		// Get the first object from the metadataObjects array.
		if let barcodeData = metadataObjects.first {
			// Turn it into machine readable code
			let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
			if let readableCode = barcodeReadable {
				// Send the barcode as a string to barcodeDetected()
				barcodeDetected(readableCode.stringValue);
			}
			
			// Vibrate the device to give the user some feedback.
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			
			// Avoid a very buzzy device.
			self.captureSession?.stopRunning()
		}
	}

	func barcodeDetected(code: String) {
		
		// Let the user know we've found something.
		let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.Destructive, handler: { action in
			
			// Remove the spaces.
			let trimmedCode = code.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			
			// EAN or UPC?
			// Check for added "0" at beginning of code.
			
			let trimmedCodeString = "\(trimmedCode)"
			var trimmedCodeNoZero: String
			
			if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
				trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
				
//				// Send the doctored UPC to DataService.searchAPI()
//				DataService.searchAPI(trimmedCodeNoZero)
				print(trimmedCodeNoZero)
			} else {
				
//				// Send the doctored EAN to DataService.searchAPI()
//				DataService.searchAPI(trimmedCodeString)
				print(trimmedCodeString)
			}
			
			self.navigationController?.popViewControllerAnimated(true)
		}))
		
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func alertScanNotAvailable() {
		// Let the user know that scanning isn't possible with the current device.
		let alertController = UIAlertController(title: "Oops!", message: "It seems we can't scan with the current device :(", preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		presentViewController(alertController, animated: true, completion: nil)
		self.captureSession = nil
	}

}
