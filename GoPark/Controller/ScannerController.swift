//
//  ScannerController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ScannerController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imgScannerFrame: UIImageView!
    
    let session = AVCaptureSession()
    var segueIdentfier = ""
    var segueConfidence = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        
        session.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.bringSubview(toFront: imgScannerFrame)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(output)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        print("Get result")
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        //SqueezeNet ParkingSignModel
        guard let model = try? VNCoreMLModel(for: ParkingSignModel().model) else {return}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {return}
            
            guard let firstObservation = results.first else {return}
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async {
                //navigaition
                if firstObservation.confidence > 0.7 {
                    self.segueIdentfier = String(firstObservation.identifier)
                    self.segueConfidence = String(firstObservation.confidence)
                    self.performSegue(withIdentifier: "ScannerToResultSegue", sender: nil)
                }
            }
            
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScannerToResultSegue"
        {
            let scannerResultController = segue.destination as? ScannerResultController
            scannerResultController?.identfier = segueIdentfier
            scannerResultController?.confidence = segueConfidence
        }
    }
    

}
