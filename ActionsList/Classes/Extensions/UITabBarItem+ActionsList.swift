//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// CAUTION: Do not use `ActionsListModel` with tab bar items when application has an ability to change device orientation.
/// There is no ability to constraint `sourceView` to tab bar item.
extension UITabBarItem {
    
    /// Creates `ActionsListModel` with the tab bar button as the source view
    ///
    /// - Parameter delegate: actions list delegate
    /// - Returns: actions list model
    ///
    /// - Note: Do not use when orientation changes supported.
    public func createActionsList(withDelegate delegate: ActionsListDelegate? = nil) -> ActionsListModel? {
        guard let view = value(forKey: "view") as? UIView
            else {
                return nil
        }
        
        let imageView = (view.subviews.filter { $0 as? UIImageView != nil }.first as? UIImageView)
        let label = (view.subviews.filter { $0 as? UILabel != nil }.first as? UILabel)
        
        let localView = UIView()
        localView.backgroundColor = UIColor.clear
        
        if let imageView = imageView {
            let localImageView = UIImageView(image: imageView.image)
            localImageView.tintColor = imageView.tintColor
            localView.addSubview(localImageView)
            localImageView.frame = imageView.frame
        }
        
        if let label = label {
            let localLabel = UILabel()
            localLabel.textColor = label.textColor
            localLabel.font = label.font
            localLabel.textAlignment = label.textAlignment
            localLabel.text = label.text
            localView.addSubview(localLabel)
            localLabel.frame = label.frame
        }
        
        return ActionsListModel(senderView: view,
                                sourceView: localView,
                                delegate: delegate)
    }
}
