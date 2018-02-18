//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

@objc public final class BackgroundView: UIView {
    
    // MARK: - Instantiate methods
    
    @available(swift, obsoleted: 0.1)
    /// - Note: Only for Objective-C
    @objc public static func instantiateWithDefaultStyle() -> BackgroundView {
        return BackgroundView.instantiate(withStyle: .default)
    }
    
    @available(swift, obsoleted: 0.1)
    /// - Note: Only for Objective-C
    @objc public static func instantiateWithCustomBackground(_ backgroundView: BackgroundViewType) -> BackgroundView {
        return BackgroundView.instantiate(withStyle: .custom(backgroundView: backgroundView))
    }
    
    public static func instantiate(withStyle style: BackgroundViewStyle) -> BackgroundView {
        let view = BackgroundView()
        
        view.backgroundView = {
            switch style {
            case .default:
                view.observeReduceTransparency()
                if view.blurAvailable {
                    return BlurredBackgroundView.instantiate(
                    withBlurEffect: BackgroundViewAppearance.common.blurEffect)
                } else {
                    return DimmedBackgroundView.instantiate(
                        withBackgroundColor: BackgroundViewAppearance.common.dimmingColor)
                }
            case .custom(let backgroundView):
                backgroundView.dismiss(
                    withDisappearDuration: 0,
                    animated: false,
                    nil)
                return backgroundView
            }
        }()
        
        view.addSubview(view.backgroundView)
        view.backgroundView.constraintToSuperview()
        
        return view
    }
    
    // MARK: - Private fields
    
    fileprivate var presented: Bool = false
    fileprivate var backgroundView: BackgroundViewType!
    private var blurAvailable: Bool {
        return UIDevice.current.isBlurAvailable
    }
    
    // MARK: - Private methods
    
    private func observeReduceTransparency() {
        NotificationCenter.actionsListCenter.addObserver(
            self,
            selector: #selector(reduceTransparencyStatusDidChange),
            name: .reduceTransparencyStatusDidChange,
            object: nil)
    }
    
    private func changeBackground(
        to newBackgroundView: BackgroundViewType,
        animated: Bool) {
        
        addSubview(newBackgroundView)
        newBackgroundView.constraintToSuperview()
        if presented {
            let changeDuration: TimeInterval = 0.2
            backgroundView?.dismiss(
                withDisappearDuration: changeDuration,
                animated: animated,
                nil)
            newBackgroundView.present(
                withAppearDuration: changeDuration,
                animated: animated,
                nil)
        }
        backgroundView?.removeFromSuperview()
        backgroundView = newBackgroundView
    }
    
    @objc private func reduceTransparencyStatusDidChange() {
        let newBackgroundView: BackgroundViewType = {
            if blurAvailable {
                return BlurredBackgroundView.instantiate(
                    withBlurEffect: BackgroundViewAppearance.common.blurEffect)
            } else {
                return DimmedBackgroundView.instantiate(
                    withBackgroundColor: BackgroundViewAppearance.common.dimmingColor)
            }
        }()
        changeBackground(
            to: newBackgroundView,
            animated: false)
    }
}

// MARK: - BackgroundViewProtocol

extension BackgroundView: BackgroundViewProtocol {
    @objc public func present(
        withAppearDuration appearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)?) {
        
        presented = true
        backgroundView.present(
            withAppearDuration: appearDuration,
            animated: animated,
            completion)
    }
    
    @objc public func dismiss(
        withDisappearDuration disappearDuration: TimeInterval,
        animated: Bool,
        _ completion: (() -> Void)?) {
        
        presented = false
        backgroundView.dismiss(
            withDisappearDuration: disappearDuration,
            animated: animated,
            completion)
    }
}
