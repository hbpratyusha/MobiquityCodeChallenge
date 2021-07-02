//
//  StaticStrings.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
let objAppDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
let defaultLocation = CLLocationCoordinate2D(latitude: 17.686815, longitude: 83.218483)
let appKey = "fae7190d7e6433ec3a45285ffcf55c86"

struct StaticStrings {
    static let found = "Found successsfully"
    static let confirmDelete = "Are you sure to delete this location?"
    static let no = "No"
    static let yes = "Yes"
    static let metric = "metric"
    static let imperial = "imperial"
    static let confirmAllDelete = "Are you sure to delete all bookmarked locations?"
}
struct DefaultKeys {
    static let unitKey = "forecast_unit"
}
enum ErrorMessages: String {
    case invalidURL = "Invalid URL"
    case noInternet = "You are offline. Please connect to internet."
    case memoryReleased = "Memory Released"
    case failedReverseGeocoding = "Failed to fetch location details"
    case unknownError = "Unknown Error"
    case cityExists = "City already exists"
    case failedLocationDelete = "Failed to delete location"
}
enum Segues: String {
    case map = "mapView"
    case cityDetail = "cityDetail"
}
enum ImageNames: String {
    case addIcon = "ic_plus"
    case closeIcon = "ic_close_new"
    case tickMark = "app_checkmark"
}
extension UIColor {
    static func defaultButtonBg(alpha: CGFloat = 1.0) -> UIColor { return UIColor(red: 124, green: 210, blue: 42, alpha: alpha) }
    static func defaultButtonTitle() -> UIColor { return UIColor.white }
    
    static func AppColor() -> UIColor { return UIColor(red: 229.0/255.0, green: 76.0/255.0, blue: 51.0/255.0, alpha: 1.0)}
    
    static func BottomBarColor() -> UIColor { return UIColor(red: 47.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)}
    
    static func AppNavigationBarBackgroundColor() -> UIColor { return UIColor(red: 229.0/255.0, green: 76.0/255.0, blue: 51.0/255.0, alpha: 1.0)}
    static func AppPlaceholderColor() -> UIColor { return UIColor(red: 152.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 1.0)}
    static func AppSelectedTextFieldColor() -> UIColor { return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)}
    static func AppTextfieldBorderLineColor() -> UIColor { return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)}
    static func AppBlackColor() -> UIColor { return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)}
    static func AppSelectedCellColor() -> UIColor { return UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)}
    static func ActLblColor() -> UIColor { return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)}
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
enum FontName : String {
    case Regular            = "HelveticaNeue"
    case Bold               = "HelveticaNeue-Bold"
    case Medium             = "HelveticaNeue-Medium"
    case Light              = "HelveticaNeue-Light"
}


extension UIFont {
    static var FontScalingFactor:CGFloat {
        var sizeScale = CGFloat(1.0)
        switch UIDevice.phoneType() {
        case .iPhone4s:
            sizeScale = 0.9
        case .iPhone6:
            sizeScale = 1.125
        case .iPhone6p:
            sizeScale = 1.2
        case .iPhoneX:
            sizeScale = 1.125
        case .iPhone11:
        sizeScale = 1.125
        case .iPad:
            sizeScale = 1.25
        default:
            break
        }
        return sizeScale
    }
    convenience init(name: FontName,size:CGFloat) {
        self.init(name: name.rawValue, size: round(size * UIFont.FontScalingFactor) )!
        
    }
    
    func getCustomFont() -> UIFont {
        if self.fontName.contains("Medium") {
            return UIFont(name:  FontName.Medium, size: self.pointSize)
        } else if self.fontName.contains("Bold") {
            return UIFont(name: FontName.Bold, size: self.pointSize)
        } else if self.fontName.contains("Light") {
            return UIFont(name: FontName.Light, size: self.pointSize)
        } else {
            return UIFont(name: .Regular, size: self.pointSize)
        }
    }
}
enum DeviceType {
    case iPhone4s
    case iPhone5
    case iPhone6
    case iPhone6p
    case iPhoneX
    case iPhone11
    case iPad
}
enum DeviceFamilyType:String {
    case iphone5_5s_5c = "iphone5_5s_5c"
    case iphone6_6s_7_8 = "iphone6_6s_7_8"
    case iphone6_6s_7_8_plus = "iphone6_6s_7_8_plus"
    case iphone_x = "iphone_x"
    case unknown = "unknown"
}
let IS_iPAD      = (UIDevice.current.userInterfaceIdiom == .pad)
let IS_IPHONE    = UI_USER_INTERFACE_IDIOM() == .phone
let IS_IPHONE5   = IS_IPHONE && UIScreen.main.bounds.size.height == 568.0
let IS_IPHONEX   = IS_IPHONE && UIScreen.main.bounds.size.height == 812.0

extension UIDevice {
    class func iphoneDeviceFamilyType () -> DeviceFamilyType{
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .iphone5_5s_5c
            case 1334:
                return .iphone6_6s_7_8
            case 1920, 2208:
                return .iphone6_6s_7_8_plus
            case 2436:
                return .iphone_x
            default:
                return .unknown
            }
        }
        return .unknown
    }
    class func phoneType () -> DeviceType {
        if IS_iPAD == true {
            return DeviceType.iPad
        }
        let screenheight:CGFloat = UIScreen.main.bounds.size.height
        switch screenheight {
        case 568:
            return DeviceType.iPhone5
        case 667:
            return DeviceType.iPhone6
        case 736:
            return DeviceType.iPhone6p
        case 812:
            return DeviceType.iPhoneX
        case 896:
        return DeviceType.iPhone11
        default:
            return DeviceType.iPhone4s
        }
    }
}
