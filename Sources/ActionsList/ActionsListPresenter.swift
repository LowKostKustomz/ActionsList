//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

final class ActionsListPresenter: UIView {
    
    // MARK: - Private fields
    
    private let appearTime: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)
    private let disappearDuration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)
    
    private weak var delegate: ActionsListDelegate?
    private var backgroundView: BackgroundView!
    private var actionsListContainer: ActionsListContainer!
    private var presenter: UIView!
    
    // MARK: - Public fields
    
    /// If list has at least one action
    var canShow: Bool {
        return actionsListContainer.canShow
    }
    
    // MARK: - Instantiate methods
    
    static func instantiate(
        withSource source: UIView,
        sender: UIView,
        delegate: ActionsListDelegate?) -> ActionsListPresenter {
        
        let actionsListPresenter = ActionsListPresenter()
        
        actionsListPresenter.delegate = delegate
        actionsListPresenter.presenter = actionsListPresenter.getPresenter(forSource: source)
        actionsListPresenter.setupBackgroundView()
        actionsListPresenter.setupActionsListContainer(withSource: source, sender: sender)
        
        NotificationCenter.default.addObserver(
            actionsListPresenter,
            selector: #selector(reduceTransparencyStatusDidChange),
            name: .reduceTransparencyStatusDidChange,
            object: nil)
        
        return actionsListPresenter
    }
    
    // MARK: - Public methods
    
    func addAction(_ action: ActionsListDefaultButtonModel) {
        actionsListContainer.addAction(action)
    }
    
    func reloadActions() {
        actionsListContainer.reloadActions()
    }
    
    func present(
        appearance: ActionsListAppearance.List,
        _ completion: (() -> Void)?) {
        
        FeedbackGenerator.instance.beginGeneration()
        
        let firstStageRelativeDuration: Double = 0.5
        let group = DispatchGroup()
        
        delegate?.actionsListWillShow?()
        presenter.addSubview(self)
        constraintToSuperview()
        
        group.enter()
        backgroundView.present(
            withAppearDuration: appearTime * firstStageRelativeDuration,
            animated: true) {
                group.leave()
        }
        
        group.enter()
        actionsListContainer.show(
            withAppearDuration: appearTime,
            firstStageRelativeDuration: firstStageRelativeDuration,
            appearance: appearance) {
                group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.delegate?.actionsListDidShow?()
            completion?()
        }
    }
    
    func dismiss(_ completion: (() -> Void)?) {
        presenter.isUserInteractionEnabled = false
        FeedbackGenerator.instance.endGeneration()
        
        let group = DispatchGroup()
        delegate?.actionsListWillHide?()
        group.enter()
        backgroundView.dismiss(withDisappearDuration: disappearDuration, animated: true) {
            group.leave()
        }
        
        group.enter()
        actionsListContainer.hide(withDisappearDuration: disappearDuration) {
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.presenter.isUserInteractionEnabled = true
            self?.removeFromSuperview()
            self?.delegate?.actionsListDidHide?()
            completion?()
        }
    }
    
    // MARK: - Private methods
    
    private func getPresenter(forSource source: UIView) -> UIView {
        if let sourceWindowRootView = source.window?.rootViewController?.view {
            return sourceWindowRootView
        }
        
        if let keyWindowRootView = UIApplication.shared.keyWindow?.rootViewController?.view {
            return keyWindowRootView
        }
        
        if let sourceWindow = source.window {
            return sourceWindow
        }
        
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow
        }
        
        return UIView()
    }
    
    private func setupBackgroundView() {
        backgroundView?.removeFromSuperview()
        backgroundView = ActionsListBackgroundViewBuilder.instance.createBackgroundView()
        if let actionsListContainer = actionsListContainer {
            insertSubview(backgroundView, belowSubview: actionsListContainer)
        } else {
            addSubview(backgroundView)
        }
        backgroundView.constraintToSuperview()
        backgroundView.isUserInteractionEnabled = false
    }
    
    private func setupActionsListContainer(
        withSource source: UIView,
        sender: UIView) {
        
        actionsListContainer = ActionsListContainer.instantiate(
            withSource: source,
            sender: sender,
            onDismissGesture: gestureDismiss)
        addSubview(actionsListContainer)
        actionsListContainer.constraintToSuperview()
        layoutIfNeeded()
    }
    
    @objc private func gestureDismiss() {
        dismiss(nil)
    }
    
    @objc private func reduceTransparencyStatusDidChange() {
        setupBackgroundView()
        backgroundView.present(
            withAppearDuration: 0,
            animated: false,
            nil)
    }
}
