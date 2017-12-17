//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

extension UIDevice {
    
    /// If the device has only taptic engine
    var hasOnlyTapticEngine: Bool {
        return platform == .iPhone6S
            || platform == .iPhone6SPlus
    }
    
    /// If device has haptic feedback
    var hasHapticFeedback: Bool {
        return platform.isNewerThan(.iPhone6S)
            || platform.isNewerThan(.iPhone6SPlus)
    }
}
