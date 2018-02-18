//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Model for actions list.
///
/// To create list just call the `init(senderView:sourceView:delegate:)` method, where:
/// * `senderView` is the view initiated the list presenting.
/// This view's alpha will be set to 0 before presenting to not be visible under `BackgroundView`
/// * `sourceView` is the copy of the `senderView`.
/// Source view will be displayed above the background view to not be dimmed or blurred with `BackgroundView`
/// List will appear with animation from under the source view and will be correctly placed in the view.
/// Also `sourceView` will "pulse" while presenting list (as the app icons on force tap).
///
/// Set up list appearance before presenting.
/// There is two ways to set up appearance:
/// * for all lists via the `ActionsListAppearance.List.common` structure
/// * for single list via the `appearance` property
///
/// To present list just call `present()` method. You could also provide completion handler or set the `delegate` to
/// handle list events.
///
/// To dismiss list just call `dismiss()` method. You could also provide completion handler or set the `delegate` to
/// handle list events.
///
/// If you have changed action's appearance, you should call `reloadActions()` method.
/// This method has no effect on list's appearance.
///
/// List generates feedback during presentation. To disable this see `FeedbackGenerator`.
///
/// ActionsListModel must be used from the main thread only.
///
/// For any kind of customizations see `ActionsListAppearance.List`.
@objc public final class ActionsListModel: NSObject {
    
    private let presenter: ActionsListPresenter
    
    /// The list appearance
    @objc public let appearance = ActionsListAppearance.List.copyCommon()
    
    /// Initializes list
    ///
    /// - Parameters:
    ///   - senderView: event sender, will be hidden while presenting list
    ///   - sourceView: list source, copy of the `senderView`, displayed above the `BackgroundView`
    ///   - delegate: list delegate
    /// - Note: Must be used from main thread only
    @objc(initWithSenderView:sourceView:delegate:)
    public init(
        senderView: UIView,
        sourceView: UIView,
        delegate: ActionsListDelegate?) {
        
        ActionsListModel.assertIsMainThread()
        presenter = ActionsListPresenter.instantiate(
            withSource: sourceView,
            sender: senderView,
            delegate: delegate)
    }
    
    /// Sets up accessibility for actions list
    ///
    /// - Parameter hint: hint to pronounce for "tap background to dismiss list" action
    @objc(setupDismissAccessibilityHint:)
    public func setupDismissAccessibility(hint: String?) {
        presenter.setupDismissAccessibility(hint: hint)
    }
    
    /// Adds action to list
    ///
    /// - Parameter action: action to add
    /// - Note: Adding actions while showing list will have no effect
    @objc(addAction:)
    public func add(action: ActionsListDefaultButtonModel) {
        action.list = self
        presenter.addAction(action)
    }
    
    /// Reloads all actions in the list
    /// - Note: You should call this method to update actions appearance while showing list
    /// - Note: Must be used from main thread only
    /// - Note: Does not affect list's appearance
    @objc(reloadActions)
    public func reloadActions() {
        assertIsMainThread()
        presenter.reloadActions()
    }
    
    /// Presents list
    ///
    /// - Parameter completion: called on presentation completion
    /// - Note: Must be used from main thread only
    @objc(presentWithCompletion:)
    public func present(_ completion: (() -> Void)? = nil) {
        assertIsMainThread()
        
        guard presenter.canShow
            else {
                return
        }
        presenter.present(appearance: appearance, completion)
    }
    
    /// Dismisses list
    ///
    /// - Parameter completion: called on dismissal completion
    /// - Note: Must be used from main thread only
    @objc(dismissWithCompletion:)
    public func dismiss(_ completion: (() -> Void)? = nil) {
        assertIsMainThread()
        presenter.dismiss(completion)
    }
    
    // MARK: - Utilities
    
    private static func assertIsMainThread() {
        precondition(Thread.isMainThread, "ActionsListModel must only be used from the main thread.")
    }
    
    private func assertIsMainThread() {
        ActionsListModel.assertIsMainThread()
    }
}
