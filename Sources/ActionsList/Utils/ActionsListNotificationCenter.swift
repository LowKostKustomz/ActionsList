//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import Foundation

let DefaultNotificationCenter = NotificationCenter.default

@objc public final class ActionsListNotificationCenter: NSObject {
    
    // MARK: - Singleton
    
    override private init() {
        super.init()
        
        DefaultNotificationCenter.addObserver(
            self,
            selector: #selector(reduceTransparencyStatusDidChange),
            name: .UIAccessibilityReduceTransparencyStatusDidChange,
            object: nil)
    }
    
    fileprivate static let instance: ActionsListNotificationCenter = ActionsListNotificationCenter()
    
    /// Internal notification center to not overload
    /// `default` notification center
    fileprivate let center = NotificationCenter()
    
    @available(*, unavailable, renamed: "Notification.Name.reduceTransparencyStatusDidChange")
    /// Use this notification name to receive notification
    /// on `Reduce Transparency` status changed.
    ///
    /// - Note: Only for Objective-C
    /// - Note: This notification posted in `ActionsListNotificationCenter.center`
    @objc public static let reduceTransparencyNotificationName = Notification.Name.reduceTransparencyStatusDidChange
    
    // MARK: - Private methods
    
    @objc private func reduceTransparencyStatusDidChange() {
        center.post(
            name: .reduceTransparencyStatusDidChange,
            object: nil)
    }
}

@objc public extension NotificationCenter {
    @objc public static var actionsListCenter: NotificationCenter {
        return ActionsListNotificationCenter.instance.center
    }
}

public extension Notification.Name {
    /// Posted to `ActionsListNotificationCenter` on Reduce Transparency status change
    public static var reduceTransparencyStatusDidChange = Notification.Name(rawValue: "com.lowkostkustomz.actionslist.ReduceTransparencyStatusDidChange")
}
