//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Content view for vibrancy visual effect view contained in background blur effect
/// view to create system look (to make light blur effect view more transparent).
private final class BlurredBackgroundVibrancyView: UIView {
    
    // MARK: - Instantiate methods
    
    static func instantiate() -> BlurredBackgroundVibrancyView {
        let vibrancy = BlurredBackgroundVibrancyView()
        vibrancy.tintAdjustmentMode = .dimmed
        return vibrancy
    }
    
    // MARK: - Overridden methods
    
    override func tintColorDidChange() {
        backgroundColor = tintColor
    }
}

// MARK: -

/// Blurred background view.
///
/// Can be used only if device supports blur and if `Reduce Transparency` toggle
/// in `General->Accessibility->Increase Contrast` is off. Otherwise system will
/// automatically make it dimmed.
@objc public final class BlurredBackgroundView: UIVisualEffectView, BackgroundViewProtocol {
    
    // MARK: - Private fields
    
    private var blurEffect = BackgroundViewAppearance.common.blurEffect
    private var vibrancyView: UIVisualEffectView!
    
    // MARK: - Instantiate methods
    
    @objc public static func instantiate(withBlurEffect effect: UIBlurEffect) -> BlurredBackgroundView {
        let backgroundView = BlurredBackgroundView()
        backgroundView.blurEffect = effect
        backgroundView.createVibrancyView(withEffect: effect)
        backgroundView.effect = nil
        return backgroundView
    }
    
    // MARK: - BackgroundViewProtocol
    
    @objc public func present(
        withAppearDuration appearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)? = nil) {
        
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
    
    @objc public func dismiss(
        withDisappearDuration disappearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)? = nil) {
        
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
    
    private func createVibrancyView(withEffect effect: UIBlurEffect) {
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: effect))
        
        let view = BlurredBackgroundVibrancyView.instantiate()
        vibrancyView.contentView.addSubview(view)
        view.constraintToSuperview()
        
        contentView.addSubview(vibrancyView)
        vibrancyView.constraintToSuperview()
        setVibrancyAlpha(0)
    }
}
