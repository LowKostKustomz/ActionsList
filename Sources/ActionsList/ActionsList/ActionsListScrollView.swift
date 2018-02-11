//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

final class ActionsListScrollView: UIScrollView {
    
    // MARK: - Private fields
    
    private var control: ActionsListControl!
    private var isReverted: Bool = false
    
    // MARK: - Instantiate methods
    
    static func instantiate(
        withComponents components: [UIView],
        blurEffect: UIBlurEffect) -> ActionsListScrollView {
        
        let list = ActionsListScrollView()
        
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
    
    // MARK: - Private methods
    
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

#if swift(>=4.0)
    private let UILayoutPriorityDefaultHigh = UILayoutPriority.defaultHigh
#endif
