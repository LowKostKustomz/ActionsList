//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Dimmed background view.
///
/// Used if device does not support blur or if `Reduce Transparency`
/// toggle in `General->Accessibility->Increase Contrast` is on.
///
/// If `Reduce Transparency` is on and blur is used, then system
/// automatically changes blur to dimming that cannot be managed.
/// To be able to control dimming color `DimmedBackgroundView` is
/// used when `Reduce Transparency` is on.
@objc public final class DimmedBackgroundView: UIView {
    
    // MARK: - Instantiate methods
    
    @objc public static func instantiate(withBackgroundColor backgroundColor: UIColor) -> DimmedBackgroundView {
        let backgroundView = DimmedBackgroundView()
        backgroundView.backgroundColor = backgroundColor
        backgroundView.alpha = 0
        return backgroundView
    }
}

// MARK: - BackgroundViewProtocol

extension DimmedBackgroundView: BackgroundViewProtocol{
    @objc public func present(
        withAppearDuration appearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: (animated ? appearDuration : 0),
            animations: {
                self.alpha = 1
        },
            completion: { (finished) in
                completion?()
        })
    }
    
    @objc public func dismiss(
        withDisappearDuration disappearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: (animated ? disappearDuration : 0),
            animations: {
                self.alpha = 0
        },
            completion: { (finished) in
                completion?()
        })
    }
}
