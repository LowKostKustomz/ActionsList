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

#if swift(>=5.0)
    private let UIAccessibilityTraitNone = UIAccessibilityTraits.none
#endif
