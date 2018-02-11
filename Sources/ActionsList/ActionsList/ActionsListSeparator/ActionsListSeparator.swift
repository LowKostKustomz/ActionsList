//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Separator view used between list items. Supports vibrancy effect.
final class ActionsListSeparatorView: UIView {
    
    // MARK: - Instantiate methods
    
    static func instantiate() -> ActionsListSeparatorView {
        let separator = ActionsListSeparatorView()
        separator.makeNotAccessible()
        return separator
    }
    
    // MARK: - Overridden methods
    
    override func tintColorDidChange() {
        backgroundColor = tintColor
    }
}
