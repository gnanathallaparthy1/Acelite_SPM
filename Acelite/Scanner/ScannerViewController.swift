//
//  ScannerViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/29/22.
//

import UIKit
import AVFoundation

@objc protocol ScannerViewDelegate: class {
	@objc func didFindScannedText(text: String)
}


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	var captureSession: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	@objc public weak var delegate: ScannerViewDelegate?
	var customView = UIView()
	@IBOutlet weak var scanView: UIView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		captureSession = AVCaptureSession()
		scanView.layer.cornerRadius = 10
		scanView.layer.borderColor = UIColor.orange.cgColor
		scanView.layer.borderWidth = 2.0
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		let videoInput: AVCaptureDeviceInput
		
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}
		
		if (captureSession.canAddInput(videoInput)) {
			captureSession.addInput(videoInput)
		} else {
			failed()
			return
		}
		//Initialize an AVCaptureMetadataOutput object and set it as the output device to the capture session.
		let metadataOutput = AVCaptureMetadataOutput()
		
		if (captureSession.canAddOutput(metadataOutput)) {
			captureSession.addOutput(metadataOutput)
			//Set delegate and use default dispatch queue to execute the call back
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
		} else {
			failed()
			return
		}
		DispatchQueue.main.async {
			//Initialize the video preview layer and add it as a sublayer.
			self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
		   // previewLayer.frame = CGRect(x: scanView.bounds.origin.x, y: scanView.bounds.origin.y, width: scanView.bounds.size.width, height: scanView.bounds.size.height)
			self.previewLayer.frame = self.view.layer.bounds
			self.previewLayer.videoGravity = .resizeAspectFill
			self.previewLayer.cornerRadius = 20
			//self.scanView.layer.addSublayer(self.previewLayer)
			self.view.layer.addSublayer(self.previewLayer)
			self.scanView.layer.cornerRadius = 20
			self.scanView.didMoveToSuperview()
			self.scanView.backgroundColor = .clear

			self.previewLayer.addSublayer(self.scanView.layer)
		   
		}
		DispatchQueue.global(qos: .background).async {
			self.captureSession.startRunning()
		}
	 
		
	}
	
	func failed() {
		let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
		captureSession = nil
	}
	override func viewDidAppear(_ animated: Bool) {
		//view.backgroundColor = UIColor.black
	 
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if (captureSession?.isRunning == false) {
			DispatchQueue.global(qos: .background).async {
				self.captureSession.startRunning()
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if (captureSession?.isRunning == true) {
			
			captureSession.stopRunning()
		}
	}
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		captureSession.stopRunning()
		
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let stringValue = readableObject.stringValue else { return }
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			found(code: stringValue)
		}
		
	}
	
	func found(code: String) {
		print(code)
		self.delegate?.didFindScannedText(text: code)
		self.navigationController?.popViewController(animated: true)
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		   super.viewWillTransition(to: size, with: coordinator)
		DispatchQueue.main.async {
			print(size.height, size.width)
			self.previewLayer.frame = self.view.bounds
		}

	   }
}
