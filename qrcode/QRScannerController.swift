//
//  QRScannerController.swift
//  qrcode
//
//  Created by Tony on 2017/1/20.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    @IBOutlet weak var videoPreviewLayerHolder: UIView!

    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var adBanner: GADBannerView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //QR動畫
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
            
            self.qrImage.alpha = 0.35
            
        }, completion: nil)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //廣告
        adBanner.adUnitID = "ca-app-pub-8264515145828397/2031183866"
        adBanner.rootViewController = self
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)
        
        //qr scanner
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = videoPreviewLayerHolder.layer.bounds;
            videoPreviewLayerHolder.clipsToBounds = true
            videoPreviewLayerHolder.layer.addSublayer(videoPreviewLayer!)

            // Start video capture.
            captureSession?.startRunning()

        }
        catch
        {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }


    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        if metadataObjects == nil || metadataObjects.count == 0
        {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
     
        if metadataObj.type == AVMetadataObjectTypeQRCode
        {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil
            {
                let code = metadataObj.stringValue

                let urlString = code!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as String

                let checkURL = NSURL(string: urlString)! as URL
                
                if UIApplication.shared.canOpenURL(checkURL)
                {

                    let url = NSURL(string: code!)! as URL

                    self.captureSession?.stopRunning()
                    
                    QRCodeManager.instance.addCode(code: code!)

                    if #available(iOS 10.0, *)
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else
                    {
                        UIApplication.shared.openURL(url)
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                        // your function here
                        self.captureSession?.startRunning()
                    }
                    
                }
                else
                {
                    NSLog(code!, 0)
                    
                    let alert = UIAlertController (title:nil, message:code, preferredStyle: .alert);
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) -> Void in
                        
                        QRCodeManager.instance.addCode(code: code!)
                        
                        self.captureSession?.startRunning()
                    })
                    
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
}

