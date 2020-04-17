//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

extension UIDevice {
    
    /// If the device is able to display blur
    var isBlurAvailable: Bool {
        guard operationSystemSupportsBlur,
            !reduceTransparencyEnabled,
            deviceSupportsBlur
            else {
                return false
        }
        
        return true
    }
    
    private var operationSystemSupportsBlur: Bool {
        if #available(iOS 8.0, *) {
            return true
        } else {
            return false
        }
    }
    
    private var reduceTransparencyEnabled: Bool {
        return UIAccessibilityIsReduceTransparencyEnabled()
    }
    
    private var deviceSupportsBlur: Bool {
        return platform.isNewerThan(.iPad3)
            && platform.isNewerThan(.iPodTouch4)
            && platform.isNewerThan(.iPhone4)
    }
}

#if swift(>=4.2)
    private func UIAccessibilityIsReduceTransparencyEnabled() -> Bool {
        return UIAccessibility.isReduceTransparencyEnabled
    }
#endif
