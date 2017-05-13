//
//  QRCodeManager.swift
//  qrcode
//
//  Created by 梁政倫 on 2017/4/8.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class QRCodeManager: NSObject
{
    static let instance = QRCodeManager ()
    
    private var _codes = NSMutableArray ()

    override init()
    {
        if UserDefaults.standard.object(forKey: "qrcodes") != nil
        {
            let codes = UserDefaults.standard.object(forKey: "qrcodes") as! NSArray
            _codes = codes.mutableCopy() as! NSMutableArray
        }
    }
    
    var codes : NSArray
    {
        get
        {
            return _codes.copy() as! NSArray
        }
    }
    
    public func addCode(code:String)
    {
        _codes.add(code);
        
        UserDefaults.standard.set(_codes, forKey: "qrcodes")
        UserDefaults.standard.synchronize()
    }
    
    public func remove(index : Int)
    {
        _codes.removeObject(at: index)
        
        UserDefaults.standard.set(_codes, forKey: "qrcodes")
        UserDefaults.standard.synchronize()
    }
    
    public func clear()
    {
        _codes.removeAllObjects()
        
        UserDefaults.standard.set(_codes, forKey: "qrcodes")
        UserDefaults.standard.synchronize()
    }
}
