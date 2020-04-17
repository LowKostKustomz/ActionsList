//
//  ActionsList
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

/// Contains appearance settings for every UI element
/// - Note: Do not change to save system look
public enum ActionsListAppearance {
    
    /// Customize action list appearance.
    ///
    /// To customize all action lists use `common` property.
    /// To customize single action list use list's model `appearance` property.
    public struct List {
        
        private init() { }

        /// Used as default appearance for all newly created lists.
        ///
        /// To change all lists default appearance change this property.
        /// - Note: Do not change to save system look
        public static let common: List = List()
        
        private static var listBlurStyle: UIBlurEffectStyle {
            if #available(iOS 10.0, *) {
                return .regular
            } else {
                return .light
            }
        }
        
        /// Blur effect applied for list background
        /// - Note: Do not change to save system look
        let listBlurEffect: UIBlurEffect = UIBlurEffect(style: List.listBlurStyle)
        
        /// Corner radius applied for list
        /// - Note: Do not change to save system look
        let listCornerRadius: CGFloat = 12
        
        /// Scale applied to list before growing
        /// - Note: Do not change to save system look
        let firstStageListScale: CGFloat = 1.5
        
        /// Scale applied to list before growing
        /// - Note: Do not change to save system look
        let firstStageSourceScale: CGFloat = 1.1
        
        /// Minimum list width
        /// - Note: Do not change to save system look
        let listMinimumWidth: CGFloat = 248
        
        /// Top and bottom list margins
        /// - Note: Do not change to save system look
        let topBottomMargin: CGFloat = 8
        
        /// Side list margin
        /// - Note: Do not change to save system look
        let sideMargin: CGFloat = 8
        
        /// List margin to source view
        /// - Note: Do not change to save system look
        let toContentMargin: CGFloat = 4
        
        /// List background color when `Reduce Transparency` toggle
        /// in `General->Accessibility->Increase Contrast` is off
        /// - Note: Do not change to save system look
        public var blurBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.2)
        
        /// List background color when `Reduce Transparency` toggle
        /// in `General->Accessibility->Increase Contrast` is on
        /// - Note: Do not change to save system look
        public var reducedTransparencyModeBackgroundColor: UIColor = UIColor.white
    }
    
    /// Custmize background views appearance.
    public struct BackgroundView {
        
        private init() { }
        
        /// Used as default appearance for all newly created background views.
        ///
        /// To change all background views default appearance change this property.
        /// - Note: Do not change to save system look
        public static let common: BackgroundView = BackgroundView()
        
        /// Blurred background view blur effect
        /// - Note: Do not change to save system look
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        
        /// Dimmed background view dimming color
        /// - Note: Do not change to save system look
        public var dimmingColor: UIColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    /// Customize actions list button appearance.
    ///
    /// To customize all buttons use `common` property.
    /// To customize single button use button's model `appearance` property.
    public struct Button {
        
        private init() { }
        
        /// Used as default appearance for all newly created buttons.
        ///
        /// To change all buttons default appearance change this property.
        /// - Note: Do not change to save system look
        public static let common: Button = Button()
        
        /// Background color applied to highlighted button
        /// - Note: Do not change to save system look
        public var highlightedBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.5)
        
        /// Background color applied to button
        /// - Note: Do not change to save system look
        public var backgroundColor: UIColor = UIColor.clear
        
        /// Color applied for button's text and image (if in template mode)
        /// - Note: Do not change to save system look
        public var tint: UIColor = UIApplication.shared.keyWindow?.tintColor ?? UIColor.black
        
        /// Color applied for button's text and image (if in template mode) in highlighted state
        /// - Note: Do not change to save system look
        public var highlightedTint: UIColor = UIApplication.shared.keyWindow?.tintColor ?? UIColor.black
        
        /// Color applied for button's text and image (if in template mode) in disabled state
        /// - Note: Do not change to save system look
        public var disabledTint: UIColor = UIColor.darkGray
        
        /// Font applied for button's text
        /// - Note: Do not change to save system look
        public var font: UIFont = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.regular)
    }
}

#if swift(>=4.0)
    private let UIFontWeightRegular = UIFont.Weight.regular
    typealias UIBlurEffectStyle = UIBlurEffect.Style
#endif
