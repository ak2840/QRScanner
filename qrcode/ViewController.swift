//
//  ViewController.swift
//  qrcode
//
//  Created by Tony on 2017/1/20.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    @IBAction func scan(_ sender: Any)
    {
        // Dispose of any resources that can be recreated.
        let qrVC = QRScannerController();
        self.present(qrVC, animated: false, completion: nil);
    }

    @IBAction func record(_ sender: Any)
    {
        let recordVC = RecordViewController ();
        self.present(recordVC, animated: false, completion: nil);
    }
}

