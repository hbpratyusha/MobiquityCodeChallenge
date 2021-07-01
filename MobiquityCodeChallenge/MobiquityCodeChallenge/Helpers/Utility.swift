//
//  Utility.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import Network
import UIKit
class Utility {
    public class func setUpNavigationBarApperence() {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        appearance.shadowImage = UIImage()
        appearance.barTintColor = UIColor.white
        appearance.isTranslucent = false
        appearance.tintColor = UIColor.AppColor()
        appearance.isTranslucent = true
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppBlackColor(), NSAttributedString.Key.font: UIFont.init(name: FontName.Bold, size: 16.0)]
        appearance.layer.shadowColor = UIColor.black.cgColor
        appearance.layer.shadowOffset = CGSize.init(width: 2.0, height: 2.0)
        appearance.layer.shadowRadius = 4.0
        appearance.layer.shadowOpacity = 1.0
    }
    public class func getErrorWith(msg: String?, code: Int = 200) -> Error {
        return NSError(domain: "", code: code, userInfo: [ NSLocalizedDescriptionKey: msg ?? ErrorMessages.unknownError.rawValue])
    }
    public class func isConnectedToNetwork(_ completion: @escaping ((_ isConnected : Bool) -> Void)) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
        }
        monitor.start(queue: .main)
    }
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    static let dateFormatterText: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    static let dateFormatterTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
}
extension Array {
    func isValid(_ index: Int) -> Bool {
        return index >= 0 && index < count
    }
    
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
extension Formatter {
    static let custom: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        return formatter
    }()
}
