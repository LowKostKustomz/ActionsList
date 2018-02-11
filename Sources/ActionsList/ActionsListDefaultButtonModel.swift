//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Model for action button.
///
/// To create button just call the `init(localizedTitle:image:action:isEnabled:)` method, where:
/// * `localizedTitle` is localized title for the button.
/// * `image` is the icon displayed near the title.
/// There will be not empty space if no image provided.
/// @1x size should be 35*35.
/// * `action` is the closure called on button tap.
/// Passes the button's model.
/// Called only if button is enabled.
/// * `isEnabled` is the flag determines wether the button is enabled.
/// If button is disabled it will not call `action` closure, will not be highlighted and will apply
/// `disabledTint` color to image (if in template mode) and title. (see `ActionsListAppearance.Button`).
///
/// Button generates feedback on highlight. To disable this see `FeedbackGenerator`.
///
/// For any kind of customizations see `ActionsListAppearance.Button`.
@objc public final class ActionsListDefaultButtonModel: NSObject {
    
    // MARK: - Equatable
    
    public static func ==(lhs: ActionsListDefaultButtonModel, rhs: ActionsListDefaultButtonModel) -> Bool {
        return lhs.localizedTitle == rhs.localizedTitle
            && lhs.image == rhs.image
    }
    
    // MARK: - Hashable
    
    override public var hashValue: Int {
        return localizedTitle.hash ^ (image?.hash ?? 0)
    }
    
    // MARK: - Public fields

    /// Localized button title
    let localizedTitle: String
    
    /// @1x size should be 35*35
    let image: UIImage?
    
    /// Action to perform on tap
    let action: ((ActionsListDefaultButtonModel) -> ())?
    
    /// Containing list
    /// - Note: Never force unwrap this value, because it can cause application crash
    @objc public weak var list: ActionsListModel?
    
    /// A Boolean value indicating wether the button is enabled
    /// - Note: You should call `list?.reloadActions()` to apply changes while showing list
    @objc public var isEnabled: Bool = true
    
    /// The button's appearance
    /// - Note: You should call `list?.reloadActions()` to apply changes while showing list
    @objc public let appearance = ActionsListAppearance.Button.copyCommon()
    
    // MARK: - Initializers
    
    /// Initializes `ActionsListDefaultButtonModel`
    ///
    /// - Parameters:
    ///   - localizedTitle: localized button title
    ///   - image: @1x size should be 35*35. If nil - will not be shown in the button
    ///   - action: action to perform on tap
    @objc(initWithLocalizedTitle:image:action:isEnabled:)
    public init(
        localizedTitle: String,
        image: UIImage?,
        action: ((ActionsListDefaultButtonModel) -> ())? = nil,
        isEnabled: Bool = true) {
        
        self.localizedTitle = localizedTitle
        self.image = image
        self.action = action
        self.isEnabled = isEnabled
    }
}
