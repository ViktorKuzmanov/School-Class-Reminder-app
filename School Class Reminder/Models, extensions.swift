//  Created by Viktor Kuzmanov on 10/2/17.

import UIKit
import Foundation
import os.log

class Day { // NEMA NSCODING I NSOBJECT
    var dayName: String
    var subjects: [Subject]?
    
    init(dayName: String) {
        self.dayName = dayName
    }
}

struct Page {
    let imageName: String
    let headerText: String
    let bodyText: String
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

//extension UIButton {
//    func addBlurEffect() {
//        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        blur.frame = self.bounds
//        blur.isUserInteractionEnabled = false
//        self.insertSubview(blur, at: 0)
//        if let imageView = self.imageView{
//            self.bringSubview(toFront: imageView)
//        }
//    }
//}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4 = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}

// EVE PRIMER ZA AKO SAKAS SO SWITCH ZA SITE DEVICES

//switch UIDevice.current.screenType.rawValue {
//case "iPhone 4 or iPhone 4S":
//    return 63
//case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
//    return 72
//case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
//    return 80
//case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
//    return 83
//case "iPhone X":
//    return 85
//default:
//    return 70
//}


