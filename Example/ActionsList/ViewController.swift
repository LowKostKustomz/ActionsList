//
//  ActionsList
//  Copyright (c) 2017 LowKostKustomz. All rights reserved.
//

import UIKit
import ActionsList

class ViewController: UIViewController {
    
    private var list: ActionsListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nil
        createBackground()
        createNavigationItems()
        
        // Clocks button
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Clock app")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(clockButtonAction(sender:)), for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -64).isActive = true
        
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        button.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    }
    
    private func createBackground() {
        let imageView = UIImageView(image: UIImage(named: "Wallpaper"))
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func createNavigationItems() {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.setTitle("Button", for: .normal)
        rightButton.sizeToFit()
        rightButton.addTarget(self, action: #selector(presentFromNavigation(button:)), for: .touchUpInside)
        
        let rightButton1 = UIButton(type: .custom)
        rightButton1.setImage(UIImage(named: "List icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton1.adjustsImageWhenHighlighted = false
        rightButton1.tintAdjustmentMode = .normal
        rightButton1.tintColor = UIColor.black
        rightButton1.sizeToFit()
        rightButton1.addTarget(self, action: #selector(presentFromNavigation(button:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightButton1),
                                              UIBarButtonItem(customView: rightButton)]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "List icon"),
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(presentFromNavigation(barButton:))),
                                             UIBarButtonItem(title: "BarButton",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(presentFromNavigation(barButton:)))]
    }
    
    @objc private func clockButtonAction(sender: UIButton) {
        let list = sender.createActionsList()
        
        list.add(action: ActionsListDefaultButtonModel(localizedTitle: "Create Alarm",
                                                       image: UIImage(named: "Alarm clock"),
                                                       action: { action in
                                                        action.list?.dismiss()
        }))
        list.add(action: ActionsListDefaultButtonModel(localizedTitle: "Start Stopwatch",
                                                       image: UIImage(named: "Stopwatch"),
                                                       action: { action in
                                                        action.list?.dismiss()
        }))
        list.add(action: ActionsListDefaultButtonModel(localizedTitle: "Start Timer",
                                                       image: UIImage(named: "Timer"),
                                                       action: { action in
                                                        action.list?.dismiss()
        }))
        
        list.present()
        self.list = list
    }
    
    @objc private func presentFromNavigation(button: UIButton) {
        let list = button.createActionsList()
        list.add(action: ActionsListDefaultButtonModel(localizedTitle: "Test",
                                                       image: UIImage(named: "Dot"),
                                                       action: { action in
                                                        action.list?.dismiss {
                                                            print("Test")
                                                        }
        }))
        
        let action2 =  ActionsListDefaultButtonModel(localizedTitle: "Test\nTest\nTest",
                                                     image: UIImage(named: "Dot"),
                                                     action: { action in
                                                        action.list?.reloadActions()
                                                        action.list?.dismiss {
                                                            print("Test")
                                                        }
        })
        action2.appearance.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightBold)
        action2.appearance.highlightedBackgroundColor = UIColor.red
        action2.appearance.highlightedTint = UIColor.yellow
        action2.appearance.tint = UIColor.blue
        action2.appearance.backgroundColor = UIColor.brown
        list.add(action: action2)
        
        list.appearance.blurBackgroundColor = UIColor.black.withAlphaComponent(0.5)
        list.present()
        self.list = list
    }
    
    @objc private func presentFromNavigation(barButton: UIBarButtonItem) {
        let list = barButton.createActionsList(withColor: UIColor.red,
                                               font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular))
        
        list?.add(action: ActionsListDefaultButtonModel(localizedTitle: "Test\nTest",
                                                        image: UIImage(named: "Dot"),
                                                        action: { action in
                                                            action.list?.dismiss {
                                                                print("Test")
                                                            }
        }))
        list?.add(action: ActionsListDefaultButtonModel(localizedTitle: "Test\nTest\nTest\nTest",
                                                        image: UIImage(named: "Dot"),
                                                        action: { action in
                                                            action.list?.dismiss {
                                                                print("Test")
                                                            }
        }))
        
        list?.present()
        self.list = list
    }
}

#if swift(>=4.0)
    private let UIFontWeightRegular = UIFont.Weight.regular
    private let UIFontWeightBold = UIFont.Weight.bold
    private let UILayoutPriorityRequired = UILayoutPriority.required
#endif
