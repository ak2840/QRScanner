//
//  RecordViewController.swift
//  qrcode
//
//  Created by 梁政倫 on 2017/3/19.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return QRCodeManager.instance.codes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let title = QRCodeManager.instance.codes[indexPath.row] as! String
        
        cell.textLabel?.text = title
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let code = QRCodeManager.instance.codes[indexPath.row] as! String
        
        let urlString = code.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as String
        
        let checkURL = NSURL(string: urlString)! as URL
        
        if UIApplication.shared.canOpenURL(checkURL)
        {
            
            let alert = UIAlertController (title:nil, message:code, preferredStyle: .alert);
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { (action:UIAlertAction!) -> Void in
                
            })
            let removeAction = UIAlertAction(title: "remove", style: .default, handler: { (action:UIAlertAction!) -> Void in
                QRCodeManager.instance.remove(index: indexPath.row)
                tableView.reloadData()
            })
            let goAction = UIAlertAction(title: "go", style: .default, handler: { (action:UIAlertAction!) -> Void in
                let url = NSURL(string: code)! as URL
                
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else
                {
                    UIApplication.shared.openURL(url)
                }
            })
            
            alert.addAction(removeAction)
            alert.addAction(cancelAction)
            alert.addAction(goAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            
            let alert = UIAlertController (title:nil, message:code, preferredStyle: .alert);
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { (action:UIAlertAction!) -> Void in
                
            })
            let removeAction = UIAlertAction(title: "remove", style: .default, handler: { (action:UIAlertAction!) -> Void in
                QRCodeManager.instance.remove(index: indexPath.row)
                tableView.reloadData()
            })
            
            alert.addAction(removeAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }

    }

    @IBAction func clear(_ sender: Any)
    {
        QRCodeManager.instance.clear()
        tableView.reloadData()
    }
    
    @IBAction func back(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
