//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Passes all touches to buttons in `stackView`.
///
/// Used for ability to recognize swipes between buttons.
final class ActionsListControl: UIControl {
    
    // MARK: - Private fields
    
    fileprivate var stackView: UIStackView!
    private var components: [UIView] = []
    
    // MARK: - Instantiate methods
    
    static func instantiate(
        withComponents components: [UIView],
        blurEffect: UIBlurEffect) -> ActionsListControl {
        
        let control = ActionsListControl()
        control.buildComponents(withComponents: components, blurEffect: blurEffect)
        control.createStackView()
        return control
    }
    
    // MARK: - Public methods
    
    func revertActionsOrder() {
        let arrangedSubviews = stackView.arrangedSubviews
        
        for subview in arrangedSubviews.reversed() {
            stackView.addArrangedSubview(subview)
        }
    }
    
    // MARK: - Private methods
    
    private func buildComponents(
        withComponents components: [UIView],
        blurEffect: UIBlurEffect) {
        
        let range = 0..<(2 * components.count - 1)
        let components = range.map { (index: Int) -> UIView in
            let isOdd: Bool = (index % 2 == 0)
            return isOdd ? components[index / 2] : ActionsListSeparatorBuilder.createSeparator(forBlurEffect: blurEffect)
        }
        self.components = components
    }
    
    private func createStackView() {
        stackView = ActionsListStackViewBuilder.createStackView(withComponents: components)
        addSubview(stackView)
        stackView.constraintToSuperview()
    }
}

// MARK: - UIControl

extension ActionsListControl {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        for subview in stackView.arrangedSubviews where subview is UIControl {
            (subview as? UIControl)?.beginTracking(touch, with: event)
        }
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        for subview in stackView.arrangedSubviews where subview is UIControl {
            (subview as? UIControl)?.continueTracking(touch, with: event)
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        for subview in stackView.arrangedSubviews where subview is UIControl {
            (subview as? UIControl)?.endTracking(touch, with: event)
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        for subview in stackView.arrangedSubviews where subview is UIControl {
            (subview as? UIControl)?.cancelTracking(with: event)
        }
    }
}
