//
//  ActionsList
//  Copyright © 2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

extension NSObject {
    func makeNotAccessible() {
        isAccessibilityElement = false
        accessibilityTraits = UIAccessibilityTraitNone
    }
}
