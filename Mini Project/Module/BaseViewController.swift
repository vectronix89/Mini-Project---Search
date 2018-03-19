//
//  BaseViewController.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SystemConfiguration
import Reachability

class BaseViewController:UIViewController{
    var storeId:String!
    var loaderView:LoaderView!
    var noInternetCount:Int = 0
    
    final func showLoader(){
        if self.loaderView != nil {
            self.loaderView.isHidden = false
            self.loaderView.removeFromSuperview()
        }
        
        if (self.navigationController == nil) {
            return
        }
        
        self.loaderView = LoaderView(frame:self.view.frame)
        self.loaderView.backgroundColor = UIColor.init(red:0/255.0, green:0/255.0, blue:0/255.0, alpha:0.2)
        self.navigationController?.view.addSubview(self.loaderView)
        self.loaderView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(UIScreen.main.bounds.size.height)
            make.center.equalTo((self.navigationController?.view)!)
        }
        
    }
    final func hideLoader() {
        
        if self.loaderView != nil {
            self.loaderView.removeFromSuperview()
        }
    }
    
    final func showToast(_ message:String){
        if self.loaderView != nil {
            self.loaderView.removeFromSuperview()
        }
        
        let height:CGFloat = heightForView(text: message, font: UIFont.systemFont(ofSize: 12), width: 300) + 10
        
        let toastLabel =
            UILabel(frame:
                CGRect(x: self.view.frame.size.width/2 - 150,
                       y: self.view.frame.size.height*0.75,
                       width: 300,
                       height: height))
        toastLabel.backgroundColor = UIColor(red: 8.0/255.0, green: 120.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, animations: {
            toastLabel.alpha = 0.0
            self.perform(#selector(self.removeToast(_:)), with: toastLabel, afterDelay: 4.0)
        })
    }
    
    @objc func removeToast(_ toastLabel:UILabel){
        toastLabel.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged(_:)), name: Notification.Name.reachabilityChanged, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
        if self.loaderView != nil {
            self.loaderView.removeFromSuperview()
        }
        
        super.viewWillDisappear(animated)
    }
    
    @objc func reachabilityStatusChanged(_ sender: NSNotification) {
        guard let networkStatus = (sender.object as? Reachability)?.connection else { return }
        switch networkStatus {
        case .none:
            print("Base ViperView No Internet, count:\(self.noInternetCount)")
            self.hideLoader()
            if self.noInternetCount > 0 {
                self.showToast("Tidak ada koneksi internet")
            }
            self.noInternetCount = noInternetCount + 1
            
            break
        case .wifi:
            print("Reachable Internet")
            break
        case .cellular:
            print("Reachable Cellular")
            break
        default:
            break
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}
