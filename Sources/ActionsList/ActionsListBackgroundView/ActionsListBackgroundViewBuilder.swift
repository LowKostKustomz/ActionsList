//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

public typealias BackgroundView = UIView & ActionsListBackgroundView

public enum ActionsListBackgroundViewType {
    case dimmed
    case blurred
    case custom(backgroundView: BackgroundView)
}

let ActionsListNotificationCenter = NotificationCenter()

extension Notification.Name {
    static var reduceTransparencyStatusDidChange = Notification.Name(rawValue: "ActionsListReduceTransparencyStatusDidChange")
}

/// Builds `BackgroundView` for list.
///
/// For customizations see `ActionsListAppearance.BackgroundView` structure.
///
/// To change default background view use `type` property.
public final class ActionsListBackgroundViewBuilder {
    
    // MARK: - Singleton
    
    private init() {
        type = .dimmed
        
        if blurAvailable {
            type = .blurred
        }
        wasCustomized = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reduceTransparencyStatusDidChange),
            name: .UIAccessibilityReduceTransparencyStatusDidChange,
            object: nil)
    }
    
    /// ActionsListBackgroundViewBuilder instance
    public static let instance = ActionsListBackgroundViewBuilder()
    
    // MARK: - Private fields
    
    private var blurAvailable: Bool {
        return UIDevice.current.isBlurAvailable
    }
    private var wasCustomized: Bool = false
    
    // MARK: - Public fields
    
    /// Change this property to set custom background views for all created further lists
    public var type: ActionsListBackgroundViewType {
        didSet {
            wasCustomized = true
        }
    }
    
    @available(*, unavailable)
    /// Changes background type to dimmed
    ///
    /// - Note: Only for Objective-C
    @objc public func setDimmedBackground() {
        type = .dimmed
    }
    
    @available(*, unavailable)
    /// Changes background type to blurred
    ///
    /// - Note: Only for Objective-C
    @objc public func setBlurredBackground() {
        type = .blurred
    }
    
    @available(*, unavailable)
    /// Changes background type to custom with given `BackgroundView`
    ///
    /// - Note: Only for Objective-C
    @objc public func setCustomBackground(_ background: BackgroundView) {
        type = .custom(backgroundView: background)
    }
    
    // MARK: - Public methods
    
    /// Resets background type to default state
    public func reset() {
        wasCustomized = false
        resetBackgroundType()
    }
    
    func createBackgroundView() -> BackgroundView {
        switch type {
        case .blurred:
            return BlurredActionsListBackgroundView.instantiate()
        case .dimmed:
            return DimmedActionsListBackgroundView.instantiate()
        case .custom(let backgroundView):
            return backgroundView
        }
    }
    
    // MARK: - Private methods
    
    @objc private func reduceTransparencyStatusDidChange() {
        resetBackgroundType()
        ActionsListNotificationCenter.post(name: .reduceTransparencyStatusDidChange, object: nil)
    }
    
    private func resetBackgroundType() {
        switch type {
        case .blurred:
            if !blurAvailable {
                type = .dimmed
                wasCustomized = false
            }
            break
        case .dimmed:
            if blurAvailable && !wasCustomized {
                type = .blurred
                wasCustomized = false
            }
            break
        case .custom:
            break
        }
    }
}
