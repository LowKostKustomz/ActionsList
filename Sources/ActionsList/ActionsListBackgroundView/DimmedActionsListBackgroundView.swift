//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Dimmed actions list background view.
///
/// Used if device does not support blur or if `Reduce Transparency` toggle
/// in `General->Accessibility->Increase Contrast` is on
final class DimmedActionsListBackgroundView: UIView, ActionsListBackgroundView {
    
    // MARK: - Instantiate methods
    
    static func instantiate() -> DimmedActionsListBackgroundView {
        let backgroundView = DimmedActionsListBackgroundView()
        backgroundView.backgroundColor = ActionsListAppearance.BackgroundView.common.dimmingColor
        backgroundView.alpha = 0
        return backgroundView
    }
    
    // MARK: - ActionsListBackgroundView
    
    func present(
        withAppearDuration appearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)?) {
        
        UIView.animate(withDuration: (animated ? appearDuration : 0),
                       animations: {
                        self.alpha = 1
        },
                       completion: { (finished) in
                        completion?()
        })
    }
    
    func dismiss(
        withDisappearDuration disappearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)?) {
        
        UIView.animate(withDuration: (animated ? disappearDuration : 0),
                       animations: {
                        self.alpha = 0
        },
                       completion: { (finished) in
                        completion?()
        })
    }
}
