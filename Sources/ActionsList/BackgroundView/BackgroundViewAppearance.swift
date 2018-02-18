//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Custmize background view appearance.
@objc public final class BackgroundViewAppearance: NSObject {
    
    private override init() { }
    
    /// Used as default appearance for all newly created background views.
    ///
    /// To change all background views default appearance change this property.
    /// - Note: Do not change to save system look
    @objc public static let common: BackgroundViewAppearance = BackgroundViewAppearance()
    
    /// Blurred background view blur effect
    /// - Note: Do not change to save system look
    @objc public var blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
    
    /// Dimmed background view dimming color
    /// - Note: Do not change to save system look
    @objc public var dimmingColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    
    static func copyCommon() -> BackgroundViewAppearance {
        let common = BackgroundViewAppearance.common
        let copy = BackgroundViewAppearance()
        copy.blurEffect = common.blurEffect
        copy.dimmingColor = common.dimmingColor
        return copy
    }
}
