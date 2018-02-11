//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Content view for vibrancy visual effect view contained in background blur effect view to create system look
/// (to make light blur effect view more transparent).
private final class BlurredActionsListBackgroundVibrancyView: UIView {
    
    // MARK: - Instantiate methods
    
    static func instantiate() -> BlurredActionsListBackgroundVibrancyView {
        let vibrancy = BlurredActionsListBackgroundVibrancyView()
        vibrancy.tintAdjustmentMode = .dimmed
        return vibrancy
    }
    
    // MARK: - Overridden methods
    
    override func tintColorDidChange() {
        backgroundColor = tintColor
    }
}

// MARK: -

/// Blurred actions list background view.
///
/// Can be used only if device supports blur and if `Reduce Transparency` toggle
/// in `General->Accessibility->Increase Contrast` is off
final class BlurredActionsListBackgroundView: UIVisualEffectView, ActionsListBackgroundView {
    
    // MARK: - Private fields
    
    private let blurEffect = ActionsListAppearance.BackgroundView.common.blurEffect
    private var vibrancyView: UIVisualEffectView!
    
    // MARK: - Instantiate methods
    
    static func instantiate() -> BlurredActionsListBackgroundView {
        let backgroundView = BlurredActionsListBackgroundView()
        backgroundView.createVibrancyView()
        backgroundView.effect = nil
        return backgroundView
    }
    
    // MARK: - ActionsListBackgroundView
    
    func present(
        withAppearDuration appearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)?) {
        
        UIView.animate(
            withDuration: (animated ? appearDuration : 0),
            animations: {
                self.effect = self.blurEffect
                self.setVibrancyAlpha(1)
        },
            completion: { (finished) in
                completion?()
        })
    }
    
    func dismiss(
        withDisappearDuration disappearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)?) {
        
        UIView.animate(
            withDuration: (animated ? disappearDuration : 0),
            animations: {
                self.effect = nil
                self.setVibrancyAlpha(0)
        },
            completion: { (finished) in
                completion?()
        })
    }
    
    // MARK: - Private methods
    
    private func setVibrancyAlpha(_ alpha: CGFloat) {
        if #available(iOS 11, *) {
            vibrancyView.alpha = alpha
        } else {
            vibrancyView.contentView.alpha = alpha
        }
    }
    
    private func createVibrancyView() {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        let view = BlurredActionsListBackgroundVibrancyView.instantiate()
        vibrancyView.contentView.addSubview(view)
        view.constraintToSuperview()
        
        contentView.addSubview(vibrancyView)
        vibrancyView.constraintToSuperview()
        setVibrancyAlpha(0)
    }
}
