//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

extension UIDevice {
    enum DevicePlatform: Decimal {
        
        /// Unknown devices
        case other              = 0
        
        // iPhone
        
        case iPhone2G           = 1
        case iPhone3G           = 10
        case iPhone3GS          = 100
        case iPhone4            = 1000
        case iPhone4S           = 10000
        
        case iPhone5            = 100000
        case iPhone5c           = 100000.1
        
        case iPhone5S           = 1000000
        
        case iPhone6            = 10000000
        case iPhone6Plus        = 10000000.1
        
        case iPhone6S           = 100000000
        case iPhone6SPlus       = 100000000.1
        case iPhoneSE           = 100000000.2
        
        /// Newer iPhone
        case anotherPhone       = 1000000000
        
        // iPod Touch
        
        case iPodTouch          = 2
        case iPodTouch2         = 20
        case iPodTouch3         = 200
        case iPodTouch4         = 2000
        case iPodTouch5         = 20000
        case iPodTouch6         = 200000
        
        /// Newer iPod
        case anotherPod         = 1000000001
        
        // iPad
        
        case iPad               = 30
        
        case iPad2              = 300
        case iPadMini           = 300.1
        
        case iPad3              = 3000
        
        /// Newer iPad
        case anotherPad         = 1000000002
        
        /// Simulators
        case simulator          = 1000000003
        
        func isNewerThan(_ another: DevicePlatform) -> Bool {
            return rawValue > another.rawValue
        }
    }
    
    private var platformString: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let platform = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return platform
    }
    
    var platform: DevicePlatform {
        switch platformString {
        // iPhone
        case "iPhone1,1":
            return .iPhone2G
        case "iPhone1,2":
            return .iPhone3G
        case "iPhone2,1":
            return .iPhone3GS
        case "iPhone3,1",
             "iPhone3,2",
             "iPhone3,3":
            return .iPhone4
        case "iPhone4,1":
            return .iPhone4S
        case "iPhone5,1",
             "iPhone5,2":
            return .iPhone5
        case "iPhone5,3",
             "iPhone5,4":
            return .iPhone5c
        case "iPhone6,1",
             "iPhone6,2":
            return .iPhone5S
        case "iPhone7,1":
            return .iPhone6Plus
        case "iPhone7,2":
            return .iPhone6
        case "iPhone8,1":
            return .iPhone6S
        case "iPhone8,2":
            return .iPhone6SPlus
        case "iPhone8,4":
            return .iPhoneSE
        // iPod
        case "iPod1,1":
            return .iPodTouch
        case "iPod2,1":
            return .iPodTouch2
        case "iPod3,1":
            return .iPodTouch3
        case "iPod4,1":
            return .iPodTouch4
        case "iPod5,1":
            return .iPodTouch5
        case "iPod7,1":
            return .iPodTouch6
        // iPad
        case "iPad1,1",
             "iPad1,2":
            return .iPad
        case "iPad2,1",
             "iPad2,2",
             "iPad2,3",
             "iPad2,4":
            return .iPad2
        case "iPad2,5",
             "iPad2,6",
             "iPad2,7":
            return .iPadMini
        case "iPad3,1",
             "iPad3,2",
             "iPad3,3":
            return .iPad3
        // Simulator
        case "x86_64",
             "i386":
            return .simulator
        // iAnother
        default:
            if platformString.contains("iPhone") {
                return .anotherPhone
            }
            if platformString.contains("iPad") {
                return .anotherPad
            }
            if platformString.contains("iPod") {
                return .anotherPod
            }
            return .other
        }
    }
}
