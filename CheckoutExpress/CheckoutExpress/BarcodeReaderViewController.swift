import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
	
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if (session?.isRunning == false) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (session?.isRunning == true) {
            session.stopRunning()
        }
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a session object.
        session = AVCaptureSession()
        
        // Set the captureDevice.
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Create input object.
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        // Add input to the session.
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            scanningNotPossible()
        }
        
        // Create output object.
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue.
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
            
        } else {
            scanningNotPossible()
        }
            
        
    
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        // Begin the capture session.
        
        session.startRunning()

        
        
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
                // Get the first object from the metadataObjects array.
                if let barcodeData = metadataObjects.first {
                    // Turn it into machine readable code
                    let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
                    if let readableCode = barcodeReadable {
                        // Send the barcode as a string to barcodeDetected()
                        barcodeDetected(code: readableCode.stringValue);
                    }
        
                    // Vibrate the device to give the user some feedback.
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
                    // Avoid a very buzzy device.
                    session.stopRunning()
                }
    }
    func scanningNotPossible() {
        // Let the user know that scanning isn't possible with the current device.
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
    }
    func searchAPI(codeNumber: String) {
        let url_var = "http://api.walmartlabs.com/v1/items?apiKey=yfahd49q5ahmbr5wjv4arrk8&upc=\(codeNumber)"
        Alamofire.request(url_var, method: .get)
            .responseJSON { response in
                var json = JSON(response.result.value!)
                let item_title = "\(json["items"][0]["name"])"
                print(item_title)
                let item_img = "\(json["items"][0]["thumbnailImage"])"
                let item_price = "\(json["items"][0]["salePrice"])"
        }
        
    }
    func barcodeDetected(code: String) {
        print("detected")
        // Let the user know we've found something.
        let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Add Item?", style: UIAlertActionStyle.destructive, handler: { action in
            
            // Remove the spaces.
            let trimmedCode = code.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            // EAN or UPC?
            // Check for added "0" at beginning of code.
            
            let trimmedCodeString = "\(trimmedCode)"
            var trimmedCodeNoZero: String
            
            //let ViewController = MainViewController()
            //let return_to_base = UIStoryboardSegue(identifier: "barcode_detected", source: self, destination: ViewController)
            //return_to_base.perform()
            
            if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
                trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
                self.searchAPI(codeNumber: trimmedCodeNoZero)
                self.performSegue(withIdentifier: "GoBack", sender: self)
                // Send the doctored UPC to DataService.searchAPI()
            } else {
                // Send the doctored EAN to DataService.searchAPI()
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

