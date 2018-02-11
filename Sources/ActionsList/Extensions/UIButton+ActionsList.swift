//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Instantiate `ActionsListModel` with `UIButton` as source view.
extension UIButton {
    
    /// Creates `ActionsListModel` with the button as the source view
    ///
    /// - Parameter delegate: actions list delegate
    /// - Returns: actions list model
    @objc public func createActionsList(withDelegate delegate: ActionsListDelegate? = nil) -> ActionsListModel {
        let localButton = UIButton()
        
        localButton.backgroundColor = UIColor.clear
        localButton.setImage(image(for: .normal), for: .normal)
        localButton.tintColor = tintColor
        localButton.titleLabel?.font = titleLabel?.font
        localButton.setTitleColor(titleColor(for: .normal), for: .normal)
        localButton.setTitle(title(for: .normal), for: .normal)
        
        return ActionsListModel(
            senderView: self,
            sourceView: localButton,
            delegate: delegate)
    }
}
