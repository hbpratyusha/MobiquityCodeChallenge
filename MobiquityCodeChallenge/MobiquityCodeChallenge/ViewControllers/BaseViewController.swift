//
//  BaseViewController.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import UIKit
class BaseViewController: UIViewController {
    private var progressIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func showAlertMessage(title:String? = nil, message:String, cancelButtonTitle:String? = "OK", completionHandler: (() -> Void)? = nil) {
        if message.count == 0 {
            return
        }
        
        let alertview = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: cancelButtonTitle ?? "OK", style: .default, handler: { (action) in
            if let handler = completionHandler {
                handler()
            }
        }))
        
        DispatchQueue.main.async {[weak self] in
            guard let weakSelf = self else {
                print("Memeory released")
                return
            }
            if let navController = weakSelf.navigationController {
                navController.present(alertview, animated: true, completion: nil)
            } else {
                weakSelf.present(alertview, animated: true, completion: nil)
            }
        }
    }
    public func showConfirmationAlert(title: String?, message: String?, cancelTitle: String?, okTitle: String?, completion: ((_ buttonIndex : Int) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: {_ in
            if let completed = completion {
                completed(0);
            }
        }))
        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: {_ in
            if let completed = completion {
                completed(1);
            }
        }))
        
        DispatchQueue.main.async {[weak self] in
            guard let weakSelf = self else {
                print("Memeory released")
                return
            }
            if let navController = weakSelf.navigationController {
                navController.present(alertController, animated: true, completion: nil)
            } else {
                weakSelf.present(alertController, animated: true, completion: nil)
            }
        }
    }
    func showProgressHud() {
        self.view.isUserInteractionEnabled = false
        self.progressIndicator.center = self.view.center
        self.progressIndicator.startAnimating()
        self.view.addSubview(self.progressIndicator)
    }
    func hideProgressHud() {
        self.view.isUserInteractionEnabled = true
        self.progressIndicator.stopAnimating()
        self.progressIndicator.removeFromSuperview()
    }
    func addLeftNavBarButton(imageName: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        button.addTarget(self, action:  #selector(self.leftButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addRightNavBarButton(imageName: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action:  #selector(self.rightButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    func addInfoNavBarButton() {
        let button = UIButton(type: .infoDark)
        button.tintColor = UIColor.AppColor()
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action:  #selector(self.infoButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func infoButtonPressed() {
        let vc = HelpViewController.make()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func rightButtonPressed() {
        
    }
    @objc func leftButtonPressed() {
    
    }
}
