//
//  ActionsList
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ActionsList;

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate, ActionsListDelegate>

- (instancetype)instantiate;

@end
