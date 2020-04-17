//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Default actions list button.
///
/// Contains icon (if image present) and title label.
///
/// Can be customized either with `ActionsListAppearance.Button` structure's properties, or with
/// `ActionsListDefaultButton`'s appearance property.
/// If appearance changed while list is showing, `ActionsListModel`'s `reloadActions()` method should be called.
///
/// Button generates feedback on highlight. To disable this see `FeedbackGenerator`.
///
/// For any kind of customizations see `ActionsListAppearance.Button`.
final class ActionsListDefaultButton: UIControl {
    
    // MARK: - Hit area
    
    private lazy var hitArea: CGRect = {
        return bounds
    }()
    
    override var bounds: CGRect {
        didSet {
            hitArea = bounds
        }
    }
    
    // MARK: - Private fields
    
    private let topMargin: CGFloat = 5
    private let bottomMargin: CGFloat = 7
    private let sideSpace: CGFloat = 13
    private let minimumLabelHeight: CGFloat = 50
    
    private var stackView: UIStackView!
    private var side: Side = .right
    
    private var titleLabel: UILabel!
    private var imageView: UIImageView?
    private var onAction: (() -> ())?
    
    // MARK: - Appearance
    
    private var appearance = ActionsListAppearance.Button.common
    
    // MARK: - Instantiate method
    
    static func instantiate(withSide side: Side) -> ActionsListDefaultButton {
        let button = ActionsListDefaultButton()
        button.side = side
        button.createStackView()
        button.addTarget(button, action: #selector(performAction), for: .touchUpInside)
        return button
    }
    
    // MARK: - Private methods
    
    @objc private func performAction() {
        onAction?()
    }
}

extension ActionsListDefaultButton: ActionsListButton {
    
    // MARK: - ActionsListButton
    
    func setup(withModel model: ActionsListDefaultButtonModel) {
        titleLabel = createLabel()
        imageView = createImageView()
        update(withModel: model)
        
        switch side {
        case .left, .center:
            if let imageView = imageView {
                stackView.addArrangedSubview(imageView)
            }
            stackView.addArrangedSubview(titleLabel)
        case .right:
            stackView.addArrangedSubview(titleLabel)
            if let imageView = imageView {
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    
    func update(withModel model: ActionsListDefaultButtonModel) {
        appearance = model.appearance
        set(localizedTitle: model.localizedTitle)
        set(image: model.image)
        updateAppearance()
        isEnabled = model.isEnabled
        onAction = {
            model.action?(model)
        }
    }
}

extension ActionsListDefaultButton {
    
    // MARK: - Components creation methods
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label
            .heightAnchor
            .constraint(greaterThanOrEqualToConstant: minimumLabelHeight)
            .isActive = true
        
        return label
    }
    
    private func set(localizedTitle: String) {
        titleLabel.attributedText = NSAttributedString(string: localizedTitle,
                                                       attributes: getTitleAttributes())
    }
    
    private func getTitleAttributes() -> [NSAttributedStringKey: Any] {
        var attributes: [NSAttributedStringKey: Any] = [:]
        
        if isEnabled {
            if isHighlighted {
                attributes[NSAttributedStringKey.foregroundColor] = appearance.highlightedTint
            } else {
                attributes[NSAttributedStringKey.foregroundColor] = appearance.tint
            }
        } else {
            attributes[NSAttributedStringKey.foregroundColor] = appearance.disabledTint
        }
        attributes[NSAttributedStringKey.font] = appearance.font
        attributes[NSAttributedStringKey.kern] = 0.5
        
        return attributes
    }
    
    private func createImageView() -> UIImageView? {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView
            .widthAnchor
            .constraint(equalToConstant: 35)
            .isActive = true
        imageView
            .heightAnchor
            .constraint(equalTo: imageView.widthAnchor)
            .isActive = true
        
        imageView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        
        return imageView
    }
    
    private func set(image: UIImage?) {
        guard let image = image
            else {
                imageView = nil
                return
        }

        if imageView == nil {
            imageView = createImageView()
        }
        imageView?.image = image
        if isEnabled {
            if isHighlighted {
                imageView?.tintColor = appearance.highlightedTint
            } else {
                imageView?.tintColor = appearance.tint
            }
        } else {
            imageView?.tintColor = appearance.disabledTint
        }
    }
    
    private func createStackView() {
        stackView = UIStackView()
        addSubview(stackView)
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = sideSpace
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView
            .topAnchor
            .constraint(equalTo: topAnchor, constant: topMargin)
            .isActive = true
        stackView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -bottomMargin)
            .isActive = true
        stackView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: sideSpace)
            .isActive = true
        stackView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -sideSpace)
            .isActive = true
    }
}

extension ActionsListDefaultButton {
    
    // MARK: - UIControl
    
    override internal var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                updateAppearance()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                updateAppearance()
            }
        }
    }
    
    private func updateAppearance() {
        if isHighlighted && isEnabled {
            backgroundColor = appearance.highlightedBackgroundColor
        } else {
            backgroundColor = appearance.backgroundColor
        }
        
        if isEnabled {
            if let title = titleLabel.attributedText?.string {
                set(localizedTitle: title)
            } else {
                titleLabel.textColor = appearance.tint
            }
            if isHighlighted {
                imageView?.tintColor = appearance.highlightedTint
            } else {
                imageView?.tintColor = appearance.tint
            }
        } else {
            if let title = titleLabel.attributedText?.string {
                set(localizedTitle: title)
            } else {
                titleLabel.textColor = appearance.disabledTint
            }
            imageView?.tintColor = appearance.disabledTint
        }
    }
    
    // MARK: Touches handling
    
    /// Checks if button is visible
    private var boundsAreVisible: Bool {
        var boundsAreVisible: Bool = true
        var optionalSuperview: UIView? = superview
        
        while let superview = optionalSuperview {
            let convertedBounds = convert(bounds,
                                          to: superview)
            if superview.bounds.intersects(convertedBounds) {
                optionalSuperview = superview.superview
            } else {
                boundsAreVisible = false
                break
            }
        }
        return boundsAreVisible
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard isEnabled
            else {
                return false
        }
        
        let currentLocation = touch.location(in: self)
        let containsCurrentLocation = hitArea.contains(currentLocation)
        
        isHighlighted = containsCurrentLocation
        
        return containsCurrentLocation
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard isEnabled
            else {
                return false
        }
        
        let currentLocation = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        let containsCurrentLocation = hitArea.contains(currentLocation)
        let containsPreviousLocation = hitArea.contains(previousLocation)
        
        let isEntering = !containsPreviousLocation && containsCurrentLocation
        let isExiting = containsPreviousLocation && !containsCurrentLocation
        
        // If touch just entered the button then
        // higlight it, otherwise unhighlight it
        
        if isEntering {
            if boundsAreVisible, #available(iOS 10.0, *) {
                FeedbackGenerator.instance.generateSelection()
            }
            isHighlighted = true
        } else if isExiting {
            isHighlighted = false
        }
        
        return isHighlighted
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let mainTouch = touch,
            isEnabled
            else {
                return
        }
        
        let currentLocation = mainTouch.location(in: self)
        
        // If touch is inside the button and button is
        // visible then send .touchUpInside control event

        if hitArea.contains(currentLocation),
            boundsAreVisible {
            sendActions(for: .touchUpInside)
        }
        
        isHighlighted = false
    }
    
    override func cancelTracking(with event: UIEvent?) {
        isHighlighted = false
    }
}

// Compatibility

#if swift(>=4.2)
    fileprivate typealias NSAttributedStringKey = NSAttributedString.Key
    fileprivate let UIAccessibilityTraitButton = UIAccessibilityTraits.button
#endif

#if swift(>=4.0)
    private let UILayoutPriorityRequired = UILayoutPriority.required
    private let NSForegroundColorAttributeName = NSAttributedStringKey.foregroundColor
#endif
