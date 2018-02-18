//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

public enum BackgroundViewStyle {
    /// If Reduce Transparency is off and device supports blur - then used `BlurredBackgroundView`, `DimmedBackgroundView` otherwise
    ///
    /// Background with this style observes Reduce Transparency status and changes itself. To force background style use `custom(backgroundView:)` style
    case `default`
    /// Your custom background view, is not changed automatically when ReduceTransparency status changed
    /// - backgroundView: instance to use for background view
    case custom(backgroundView: BackgroundViewType)
}

/// Builds `BackgroundView`.
///
/// For customizations see `BackgroundViewAppearance` structure.
///
/// To change default background view use `style` property.
@objc public final class BackgroundViewBuilder: NSObject {
    
    // MARK: - Singleton
    
    private override init() {
        style = .default
        super.init()
    }
    
    @objc public static let instance = BackgroundViewBuilder()
    
    // MARK: - Private fields
    
    private var blurAvailable: Bool {
        return UIDevice.current.isBlurAvailable
    }
    
    // MARK: - Public fields
    
    /// Change this property to set custom background views for all created further lists
    public var style: BackgroundViewStyle
    
    @available(swift, obsoleted: 0.1)
    /// Changes background style to default
    ///
    /// - Note: Only for Objective-C
    @objc public func setDefaultBackgroundStyle() {
        style = .default
    }
    
    @available(swift, obsoleted: 0.1)
    /// Changes background style to custom with given background view
    ///
    /// - Note: Only for Objective-C
    @objc public func setCustomBackground(_ background: BackgroundViewType) {
        style = .custom(backgroundView: background)
    }
    
    // MARK: - Public methods
    
    @objc public func createBackgroundView() -> BackgroundViewType {
        return BackgroundView.instantiate(withStyle: style)
    }
}
