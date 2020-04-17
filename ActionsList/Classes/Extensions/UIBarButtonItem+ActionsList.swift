//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// CAUTION: Not usable because in iOS 11 `UIBarButtonItem` content has not the same frame as overlay button's content.
///
/// Instead, create `UIBarButtonItem` item from `UIButton` (with `init(customView: UIView)` method),
/// and instantiate list from `UIButton` extension's method (works for any iOS version up to 11).
extension UIBarButtonItem {
    
    /// Creates `ActionsListModel` with the bar buttton item as the source view
    ///
    /// - Parameter delegate: actions list delegate
    /// - Returns: actions list model
    ///
    /// - Note: Obsoleted in iOS 11
    @available(iOS, obsoleted: 11.0, message: "`UIBarButtonItem` content has not the same frame as overlay button's content. Use `UIButton` and `UIBarButtonItem`'s `init(customView: UIView)` method instead")
    public func createActionsList(withColor color: UIColor? = UIApplication.shared.keyWindow?.tintColor,
                                  font: UIFont? = nil,
                                  delegate: ActionsListDelegate? = nil) -> ActionsListModel? {
        guard let itemView = value(forKey: "view") as? UIView
            else {
                return nil
        }
        
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        button.tintColor = color
        button.titleLabel?.font = font
        button.setTitleColor(color, for: .normal)
        button.setTitle(title, for: .normal)
        
        return ActionsListModel(senderView: itemView,
                                sourceView: button,
                                delegate: delegate)
    }
}

