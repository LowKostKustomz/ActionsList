//
//  ActionsList
//  Copyright © 2017-2018 LowKostKustomz. All rights reserved.
//

import UIKit
import ActionsList

class TabBarItemModel {
    typealias ImageName = String
    
    enum TabBarItemType {
        case custom(String?, ImageName?)
    }
    
    enum TabBarItemActionType {
        case controller(UIViewController)
        case action((TabBarItemModel) -> ())
    }
    
    let type: TabBarItemType
    let actionType: TabBarItemActionType
    var viewController: UIViewController? = nil
    
    init(type: TabBarItemType,
         actionType: TabBarItemActionType) {
        self.type = type
        self.actionType = actionType
    }
}

class TabBarViewController: UITabBarController {
    
    private var mainTabItem: TabBarItemModel!
    private var menuTabItem1: TabBarItemModel!
    private var menuTabItem2: TabBarItemModel!
    private var menuTabItem3: TabBarItemModel!
    private var menuTabItem4: TabBarItemModel!
    
    fileprivate var items: [TabBarItemModel] = []
    private var shouldReset: Bool = true
    private var list: ActionsListModel?
    
    static func instantiate() -> TabBarViewController {
        let tabBar = TabBarViewController()
        return tabBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldReset {
            shouldReset = false
            resetItems()
        }
    }
    
    private func setupItems() {
        mainTabItem = TabBarItemModel(type: .custom("Main", "Home icon"),
                                      actionType: .controller(ViewController()))
        
        menuTabItem1 = TabBarItemModel(type: .custom(nil, "List icon"),
                                       actionType: .action({ (model) in
                                        self.showMenu(fromModel: model)
                                       }))
        
        menuTabItem2 = TabBarItemModel(type: .custom("Big Menu", "List icon"),
                                       actionType: .action({ (model) in
                                        self.showMenu(fromModel: model)
                                       }))
        
        menuTabItem3 = TabBarItemModel(type: .custom("Bigger Menu", nil),
                                       actionType: .action({ (model) in
                                        self.showMenu(fromModel: model)
                                       }))
        
        menuTabItem4 = TabBarItemModel(type: .custom("Biggest Menu", "List icon"),
                                       actionType: .action({ (model) in
                                        self.showMenu(fromModel: model)
                                       }))
    }
    
    private func showMenu(fromModel model: TabBarItemModel) {
        if let controller = model.viewController,
            let item = controller.tabBarItem {
            showMenu(fromItem: item, model: model)
        }
    }
    
    private func showMenu(fromItem item: UITabBarItem,
                          model: TabBarItemModel) {
        guard let list = item.createActionsList(withDelegate: self)
            else {
                return
        }
        
        switch model.type {
        case .custom(let title, _):
            switch title ?? "" {
            case "Big Menu":
                addActions(4, toList: list)
            case "Bigger Menu":
                addActions(8, toList: list)
            case "Biggest Menu":
                addActions(16, toList: list)
            default:
                addActions(2, toList: list)
            }
        }
        
        list.present()
        self.list = list
    }
    
    private func addActions(_ count: Int,
                            toList list: ActionsListModel) {
        for i in 1...count {
            let title: String = [String](repeating: "Action number \(i)", count: i).joined(separator: "\n")
            
            list.add(action: ActionsListDefaultButtonModel(localizedTitle: title,
                                                           image: UIImage(named: "Dot"),
                                                           action: { action in
                                                            action.list?.dismiss()
            }))
        }
    }
    
    private func resetItems() {
        items = [mainTabItem, menuTabItem1, menuTabItem2, menuTabItem3, menuTabItem4]
        
        viewControllers = items.enumerated().map {
            let element = $0.element
            let index = $0.offset
            var viewController: UIViewController
            if let vc = element.viewController {
                viewController = vc
            } else {
                switch element.actionType {
                case .action:
                    viewController = UIViewController()
                case .controller(let controller):
                    viewController = controller
                }
                viewController = UINavigationController(rootViewController: viewController)
                element.viewController = viewController
            }
            
            var tabBarItem: UITabBarItem
            
            switch element.type {
            case .custom(let title, let imageName):
                tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName ?? ""), tag: index)
                if title == nil {
                    let offset: CGFloat = 10
                    tabBarItem.imageInsets = UIEdgeInsets(top: offset / 2, left: 0, bottom: -offset / 2, right: 0)
                }
            }
            
            tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1)
            viewController.tabBarItem = tabBarItem
            return viewController
        }
    }
}

extension TabBarViewController: ActionsListDelegate {
    func actionsListWillShow() {
        if #available(iOS 10, *) {
            tabBar.tintColor = tabBar.unselectedItemTintColor
        }
    }
    
    func actionsListDidHide() {
        tabBar.tintColor = view.window?.tintColor
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.index(of: viewController),
            index < items.count {
            let item = items[index]
            switch item.actionType {
            case .action(let action):
                action(item)
                return false
            case .controller:
                self.selectedIndex = index
                return true
            }
        }
        return true
    }
}
