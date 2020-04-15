//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

final class ActionsListScrollView: UIScrollView {
    
    // MARK: - Private fields
    
    private var control: ActionsListControl!
    private var isReverted: Bool = false
    
    // MARK: - Public fields
    
    override var accessibilityElements: [Any]? {
        get {
            return control.accessibilityElements
        }
        set { }
    }
    
    // MARK: - Instantiate methods
    
    static func instantiate(
        withComponents components: [UIView],
        blurEffect: UIBlurEffect) -> ActionsListScrollView {
        
        let list = ActionsListScrollView()
        
        DefaultNotificationCenter.addObserver(
            list,
            selector: #selector(focusedElementChanged(_:)),
            name: .UIAccessibilityElementFocused,
            object: nil)
        
        list.makeNotAccessible()
        
        list.bounces = false
        list.showsVerticalScrollIndicator = false
        list.showsHorizontalScrollIndicator = false
        list.clipsToBounds = true
        
        list.createControl(
            withComponents: components,
            blurEffect: blurEffect)
        
        return list
    }
    
    // MARK: - Public methods
    
    func revertActionsOrder() {
        control.revertActionsOrder()
        isReverted = !isReverted
        if isReverted {
            setContentOffset(CGPoint(x: 0, y: contentSize.height - bounds.height), animated: false)
        } else {
            setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        switch direction {
        case .down,
             .up:
            let contentHeight = contentSize.height
            let viewHeight = bounds.height
            
            if contentHeight <= viewHeight {
                return false
            }

            let currentOffset = contentOffset
            let newOffsetY: CGFloat
            if direction == .up {
                if currentOffset.y == 0 {
                    return false
                }
                newOffsetY = max(0, currentOffset.y - viewHeight)
            } else {
                if viewHeight + currentOffset.y == contentHeight {
                    return false
                }
                newOffsetY = min(contentHeight - viewHeight, currentOffset.y + viewHeight)
            }
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.contentOffset = CGPoint(x: currentOffset.x, y: newOffsetY)
            },
                completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    var elements = strongSelf.control.accessibilityActions
                    if direction == .up {
                        elements.reverse()
                    }
                    
                    let bounds = strongSelf.bounds
                    
                    if let element = elements.first(where: { [weak self] (view) -> Bool in
                        let viewInBounds = view.convert(view.bounds, to: self)
                        return bounds.intersects(viewInBounds)
                    }) {
                        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, element)
                    }
            })
            return true
        case .left,
             .right,
             .next,
             .previous:
            return false
        }
    }
    
    // MARK: - Private methods
    
    @objc private func focusedElementChanged(_ notification: Notification) {
        if let element = notification.userInfo?[UIAccessibilityFocusedElementKey] as? UIView,
            element.isDescendant(of: self),
            !bounds.contains(element.convert(element.bounds, to: self)) {
            scrollRectToVisible(element.frame, animated: true)
        }
    }
    
    private func createControl(
        withComponents components: [UIView],
        blurEffect: UIBlurEffect) {
        
        control = ActionsListControl.instantiate(
            withComponents: components,
            blurEffect: blurEffect)
        addSubview(control)
        control.constraintToSuperview()
        widthAnchor.constraint(equalTo: control.widthAnchor).isActive = true
        
        let optionalConstraint = heightAnchor.constraint(equalTo: control.heightAnchor)
        optionalConstraint.priority = UILayoutPriorityDefaultHigh
        optionalConstraint.isActive = true
        
        setContentOffset(CGPoint.zero, animated: false)
    }
}

// Compatibility

#if swift(>=5.0)
private let UIAccessibilityFocusedElementKey = UIAccessibility.focusedElementUserInfoKey
private let UIAccessibilityLayoutChangedNotification = UIAccessibility.Notification.layoutChanged
private func UIAccessibilityPostNotification(_ notification: UIAccessibility.Notification, _ argument: Any?) {
    UIAccessibility.post(notification: notification, argument: argument)
}

private extension Notification.Name {
    static var UIAccessibilityElementFocused: Notification.Name {
        return UIAccessibility.elementFocusedNotification
    }
}
#endif

#if swift(>=4.0)
    private let UILayoutPriorityDefaultHigh = UILayoutPriority.defaultHigh
#endif
