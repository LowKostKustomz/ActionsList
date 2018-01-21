//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import Foundation

/// Protocol to implement for actions list button model
protocol ActionsListButton {
    
    /// Should setup button with `model`
    ///
    /// - Parameter model: model setup button with
    func setup(withModel model: ActionsListDefaultButtonModel)
    
    /// Should update button with `model`
    ///
    /// - Parameter model: model setup button with
    func update(withModel model: ActionsListDefaultButtonModel)
}
