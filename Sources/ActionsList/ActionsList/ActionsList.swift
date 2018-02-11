//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

final class ActionsList: UIVisualEffectView {
    
    // MARK: - Private fields
    
    private(set) var content: ActionsListScrollView!
    private var appearance: ActionsListAppearance.List!
    
    // MARK: - Public fields
    
    override var accessibilityElements: [Any]? {
        get {
            return content.accessibilityElements
        }
        set { }
    }
    
    // MARK: - Instantiate methods
    
    static func instantiate(
        withComponents components: [UIView],
        appearance: ActionsListAppearance.List) -> ActionsList {
        
        let list = ActionsList()
        list.makeNotAccessible()
        list.appearance = appearance
        
        list.setupContent(
            withComponents: components,
            blurEffect: appearance.listBlurEffect)
        list.layer.cornerRadius = appearance.listCornerRadius
        list.clipsToBounds = true
        
        list.setupAppearance()
        
        NotificationCenter.default.addObserver(
            list,
            selector: #selector(reduceTransparencyStatusDidChange),
            name: .reduceTransparencyStatusDidChange,
            object: nil)
        
        return list
    }
    
    // MARK: - Public methods
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        return content.accessibilityScroll(direction)
    }
    
    func revertActionsOrder() {
        content.revertActionsOrder()
    }
    
    // MARK: - Private methods
    
    @objc private func reduceTransparencyStatusDidChange() {
        setupAppearance()
    }
    
    private func setupAppearance() {
        if UIDevice.current.isBlurAvailable {
            effect = appearance.listBlurEffect
            backgroundColor = appearance.blurBackgroundColor
        } else {
            effect = nil
            backgroundColor = appearance.reducedTransparencyModeBackgroundColor
        }
    }
    
    private func setupContent(
        withComponents components: [UIView],
        blurEffect: UIBlurEffect) {
        
        content = ActionsListScrollView.instantiate(
            withComponents: components,
            blurEffect: blurEffect)
        contentView.addSubview(content)
        content.constraintToSuperview()
    }
}
