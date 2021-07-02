//
//  HelpViewController.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 02/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class HelpViewController: UIViewController {
    @IBOutlet weak var wvHelp: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wvHelp?.scalesLargeContentImage = true
        if let path = Bundle.main.path(forResource: "help", ofType: "htm") {
            let url = URL(fileURLWithPath: path)
            self.wvHelp?.loadHTMLString(try! String(contentsOf: url), baseURL: url.deletingLastPathComponent())
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
extension HelpViewController {
    class func make() -> HelpViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "HelpVC") as? HelpViewController else { preconditionFailure() }
        return controller
    }
}
