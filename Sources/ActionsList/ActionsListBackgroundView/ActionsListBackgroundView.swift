//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Implement this protocol to create custom background view for dimming the content under the list.
public protocol ActionsListBackgroundView {
    
    /// Presents background view with `appearDuration`
    ///
    /// - Parameters:
    ///   - appearDuration: appear duration
    ///   - animated: if appear should be animated
    ///   - completion: called on presentation completion
    func present(withAppearDuration appearDuration: TimeInterval,
                 animated: Bool,
                 _ completion: (() -> Void)?)
    
    /// Dismisses background view with `disappearDuration`
    ///
    /// - Parameters:
    ///   - disappearDuration: disappear duration
    ///   - animated: if disappear should be animated
    func dismiss(withDisappearDuration disappearDuration: TimeInterval,
                 animated: Bool,
                 _ completion: (() -> Void)?)
}
