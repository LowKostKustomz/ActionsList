//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Creates `ActionsListSeparator` with vibrancy for given `blurEffect`
struct ActionsListSeparatorBuilder {
    
    private init() { }
    
    /// Creates vibrancy view with `ActionsListSeparatorView` inside
    ///
    /// - Parameter blurEffect: blur effect applied to root `UIVisualEffectView`
    /// - Returns: separator view
    static func createSeparator(forBlurEffect blurEffect: UIBlurEffect) -> UIView {
        let separator = ActionsListSeparatorView.instantiate()
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.contentView.addSubview(separator)
        
        separator.constraintToSuperview()
        separator
            .heightAnchor
            .constraint(equalToConstant: 1 / UIScreen.main.scale)
            .isActive = true
        
        return vibrancyView
    }
}
