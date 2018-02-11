//
//  ActionsList
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

struct ActionsListStackViewBuilder {
    
    private init() { }
    
    static func createStackView(withComponents components: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: components)
        
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }
}
