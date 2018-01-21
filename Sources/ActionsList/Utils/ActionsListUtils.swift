//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

enum Side {
    case left
    case center
    case right
}

@objc public protocol ActionsListDelegate: class {
    
    /// Called before list showing
    @objc optional func actionsListWillShow()
    
    /// Called after list showing
    @objc optional func actionsListDidShow()
    
    /// Called before list hiding
    @objc optional func actionsListWillHide()
    
    /// Called after list hiding
    @objc optional func actionsListDidHide()
}
