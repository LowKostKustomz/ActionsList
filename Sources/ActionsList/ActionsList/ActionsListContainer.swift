//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

final class ActionsListContainer: UIView {
    
    // MARK: - Private fields

    private var listContainerBlurView: ActionsList!
    private var actionsButtonsDictionary: [ActionsListDefaultButtonModel: ActionsListButton] = [:]
    private var actions: [ActionsListDefaultButtonModel] = []
    private var source: UIView!
    private var sender: UIView!
    private var appearance: ActionsListAppearance.List = ActionsListAppearance.List.copyCommon()
    private var onDismiss: (() -> Void)?

    private var statusBarHeight: CGFloat {
        return UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
    }
    
    private var sourceBoundsInPresenter: CGRect {
        return source.convert(source.bounds, to: self)
    }
    
    private var listContainerBlurViewBoundsInPresenter: CGRect {
        return listContainerBlurView.convert(listContainerBlurView.bounds, to: self)
    }
    
    private var side: Side {
        switch sourceBoundsInPresenter.midX {
        case 0..<bounds.midX:
            return .left
        case bounds.midX:
            return .center
        default:
            return .right
        }
    }

    private var bottomFreeSpaceHeight: CGFloat {
        return frame.height - (sourceBoundsInPresenter.maxY + appearance.topBottomMargin + appearance.toContentMargin)
    }

    private var topFreeSpaceHeight: CGFloat {
        return sourceBoundsInPresenter.minY - appearance.topBottomMargin - appearance.toContentMargin - statusBarHeight
    }
    
    // MARK: - Public fields
    
    var canShow: Bool {
        return actions.count != 0
    }
    
    // MARK: - Instantiate methods
    
    static func instantiate(withSource source: UIView,
                            sender: UIView,
                            onDismissGesture: @escaping () -> Void) -> ActionsListContainer {
        let list = ActionsListContainer()
        list.sender = sender
        source.isUserInteractionEnabled = false
        list.source = source
        list.bringSubview(toFront: list.source)
        list.onDismiss = onDismissGesture
        list.setupDismissGestureRecognizer()
        
        return list
    }
    
    // MARK: - Public methods

    func addAction(_ action: ActionsListDefaultButtonModel) {
        actions.append(action)
    }
    
    func reloadActions() {
        for (key, value) in actionsButtonsDictionary {
            value.update(withModel: key)
        }
    }
    
    func show(withAppearDuration appearDuration: TimeInterval,
              firstStageRelativeDuration: Double,
              appearance: ActionsListAppearance.List,
              _ completion: (() -> Void)?) {
        self.appearance = appearance
        
        setupSourceView()
        
        layoutIfNeeded()
        
        let actionButtons: [UIView] = actions.map { [weak self] (model: ActionsListDefaultButtonModel) -> ActionsListDefaultButton in
            let button = ActionsListDefaultButton.instantiate(withSide: side)
            button.setup(withModel: model)
            self?.actionsButtonsDictionary[model] = button
            return button
        }
        listContainerBlurView = ActionsList.instantiate(withComponents: actionButtons,
                                                        appearance: appearance)
        addSubview(listContainerBlurView)
        listContainerBlurView.translatesAutoresizingMaskIntoConstraints = false
        
        setupLimitingConstraints()
        setupListConstraints()
        bringSubview(toFront: source)
        
        layoutIfNeeded()
        
        present(withAppearDuration: appearDuration,
                firstStageRelativeDuration: firstStageRelativeDuration,
                completion: completion)
    }

    func hide(withDisappearDuration disappearDuration: TimeInterval,
                     _ completion: (() -> Void)?) {
        let transform = self.transform(listContainerBlurView.transform,
                                       fromRect: listContainerBlurViewBoundsInPresenter,
                                       toRect: sourceBoundsInPresenter)
        
        UIView
            .animate(
                withDuration: disappearDuration,
                animations: {
                    self.setListContainerBlurViewAlpha(0)
                    self.listContainerBlurView.transform = transform
            }) { [weak self] (_) in
                self?.sender.alpha = 1
                self?.source.alpha = 0
                self?.removeFromSuperview()
                completion?()
        }
    }
    
    // MARK: - Private methods
    
    private func setupDismissGestureRecognizer() {
        let dismissGestureView: UIView = UIView()
        
        let dismissGestureRecognizer = UITapGestureRecognizer()
        dismissGestureRecognizer.cancelsTouchesInView = false
        dismissGestureRecognizer.addTarget(self, action: #selector(dismiss))
        dismissGestureView.addGestureRecognizer(dismissGestureRecognizer)
        
        addSubview(dismissGestureView)
        sendSubview(toBack: dismissGestureView)
        dismissGestureView.constraintToSuperview()
    }
    
    @objc private func dismiss() {
        onDismiss?()
    }
    
    private func present(withAppearDuration appearDuration: TimeInterval,
                         firstStageRelativeDuration: Double,
                         completion: (() -> ())?) {
        let transform = self.transform(listContainerBlurView.transform,
                                       fromRect: listContainerBlurViewBoundsInPresenter,
                                       toRect: sourceBoundsInPresenter)
        
        let alpha: CGFloat = 0
        sender.alpha = 0
        source.alpha = 1
        setListContainerBlurViewAlpha(alpha)
        listContainerBlurView.content.alpha = alpha
        listContainerBlurView.transform = transform
        
        UIView
            .animateKeyframes(
                withDuration: appearDuration,
                delay: 0,
                options: [UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.curveEaseOut.rawValue)],
                animations: {
                    UIView
                        .addKeyframe(
                            withRelativeStartTime: 0,
                            relativeDuration: firstStageRelativeDuration)
                        { [weak self] in
                            self?.setListContainerBlurViewAlpha(1)
                            self?.source.transform = (self?
                                .source
                                .transform
                                .scaledBy(x: self?.appearance.firstStageSourceScale ?? 0,
                                          y: self?.appearance.firstStageSourceScale ?? 0)) ?? CGAffineTransform.identity
                            self?.listContainerBlurView.transform = (self?
                                .listContainerBlurView
                                .transform
                                .scaledBy(x: self?.appearance.firstStageListScale ?? 0,
                                          y: self?.appearance.firstStageListScale ?? 0)) ?? CGAffineTransform.identity
                    }
                    
                    UIView
                        .addKeyframe(
                            withRelativeStartTime: firstStageRelativeDuration,
                            relativeDuration: 1 - firstStageRelativeDuration)
                        { [weak self] in
                            if #available(iOS 10.0, *) {
                                FeedbackGenerator.instance.generateOpen()
                            }
                            self?.listContainerBlurView.content.alpha = 1
                            self?.source.transform = CGAffineTransform.identity
                            self?.listContainerBlurView.transform = CGAffineTransform.identity
                    }
            }) { finished in
                completion?()
        }
    }
    
    // MARK: - Utils
    
    private func setListContainerBlurViewAlpha(_ alpha: CGFloat) {
        if #available(iOS 11, *) {
            listContainerBlurView.alpha = alpha
        } else {
            listContainerBlurView.contentView.alpha = alpha
        }
    }
    
    private func transform(_ transform: CGAffineTransform,
                           fromRect from: CGRect,
                           toRect to: CGRect) -> CGAffineTransform {
        let xScale: CGFloat = to.width / from.width
        let yScale: CGFloat = to.height / from.height
        let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: xScale, y: yScale)
        
        let xTranslate: CGFloat = to.midX - from.midX
        let yTranslate: CGFloat = to.midY - from.midY
        let translateTransform: CGAffineTransform = CGAffineTransform(translationX: xTranslate, y: yTranslate)
        
        return transform
            .concatenating(scaleTransform)
            .concatenating(translateTransform)
    }
    
    private func setupSourceView() {
        addSubview(source)
        source.translatesAutoresizingMaskIntoConstraints = false
        source
            .topAnchor
            .constraint(equalTo: sender.topAnchor)
            .isActive = true
        source
            .bottomAnchor
            .constraint(equalTo: sender.bottomAnchor)
            .isActive = true
        source
            .leadingAnchor
            .constraint(equalTo: sender.leadingAnchor)
            .isActive = true
        source
            .trailingAnchor
            .constraint(equalTo: sender.trailingAnchor)
            .isActive = true
    }
    
    private func setupListConstraints() {
        switch side {
        case .left:
            let optionalConstraint = listContainerBlurView.leadingAnchor.constraint(equalTo: source.leadingAnchor)
            optionalConstraint.priority = UILayoutPriorityDefaultLow
            optionalConstraint.isActive = true
        case .right:
            let optionalConstraint = listContainerBlurView.trailingAnchor.constraint(equalTo: source.trailingAnchor)
            optionalConstraint.priority = UILayoutPriorityDefaultLow
            optionalConstraint.isActive = true
        case .center:
            let optionalConstraint = listContainerBlurView.centerXAnchor.constraint(equalTo: source.centerXAnchor)
            optionalConstraint.priority = UILayoutPriorityDefaultLow
            optionalConstraint.isActive = true
        }
        
        layoutIfNeeded()
        
        if sourceBoundsInPresenter.width > listContainerBlurViewBoundsInPresenter.width {
            source
                .widthAnchor
                .constraint(lessThanOrEqualTo: listContainerBlurView.widthAnchor)
                .isActive = true
        } else {
            listContainerBlurView
                .widthAnchor
                .constraint(equalToConstant: appearance.listMinimumWidth)
                .isActive = true
        }
        
        if listContainerBlurViewBoundsInPresenter.height > bottomFreeSpaceHeight,
            bottomFreeSpaceHeight < topFreeSpaceHeight {
            listContainerBlurView
                .bottomAnchor
                .constraint(equalTo: source.topAnchor, constant: -appearance.toContentMargin)
                .isActive = true
            layoutIfNeeded()
            listContainerBlurView.revertActionsOrder()
        } else {
            listContainerBlurView
                .topAnchor
                .constraint(equalTo: source.bottomAnchor, constant: appearance.toContentMargin)
                .isActive = true
        }
    }
    
    private func setupLimitingConstraints() {
        if #available(iOS 11, *) {
            listContainerBlurView
                .topAnchor
                .constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: appearance.topBottomMargin)
                .isActive = true
            listContainerBlurView
                .bottomAnchor
                .constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -appearance.topBottomMargin)
                .isActive = true
        } else {
            listContainerBlurView
                .topAnchor
                .constraint(greaterThanOrEqualTo: topAnchor, constant: appearance.topBottomMargin + statusBarHeight)
                .isActive = true
            listContainerBlurView
                .bottomAnchor
                .constraint(lessThanOrEqualTo: bottomAnchor, constant: -appearance.topBottomMargin)
                .isActive = true
        }
        listContainerBlurView
            .leadingAnchor
            .constraint(greaterThanOrEqualTo: leadingAnchor, constant: appearance.sideMargin)
            .isActive = true
        listContainerBlurView
            .trailingAnchor
            .constraint(lessThanOrEqualTo: trailingAnchor, constant: -appearance.sideMargin)
            .isActive = true
    }
}

// Compatibility

#if swift(>=4.0)
    private let UILayoutPriorityDefaultLow = UILayoutPriority.defaultLow
#endif
