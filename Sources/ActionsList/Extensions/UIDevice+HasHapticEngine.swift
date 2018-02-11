//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

extension UIDevice {
    
    /// If the device has only taptic engine
    var hasOnlyTapticEngine: Bool {
        switch platform {
        case .iPhone(let model):
            return model == .iPhone6S || model == .iPhone6SPlus
        default:
            return false
        }
    }
    
    /// If device has haptic feedback
    var hasHapticFeedback: Bool {
        return platform.isNewerThan(UIDevice.DevicePlatform.iPhoneModel.iPhone6S)
            || platform.isNewerThan(UIDevice.DevicePlatform.iPhoneModel.iPhone6SPlus)
    }
}
