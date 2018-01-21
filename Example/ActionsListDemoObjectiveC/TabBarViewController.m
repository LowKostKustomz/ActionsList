//
//  ActionsList
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewController.h"

@interface TabBarItemModel : NSObject

@property (nonatomic, strong, nullable) NSString* title;
@property (nonatomic, strong, nullable) UIImage* image;
@property (nonatomic, copy, nullable) void (^action)(void);
@property (nonatomic, strong, nullable) UIViewController* controller;
@property (nonatomic, strong, nullable) UIViewController* cachedViewController;

@end

@implementation TabBarItemModel

@end

@interface TabBarViewController ()

@end

@implementation TabBarViewController {
    TabBarItemModel* mainTabItem;
    TabBarItemModel* menuTabItem1;
    TabBarItemModel* menuTabItem2;
    TabBarItemModel* menuTabItem3;
    TabBarItemModel* menuTabItem4;
    
    NSMutableArray<TabBarItemModel*>* items;
    BOOL shouldReset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shouldReset = YES;
    
    [self setupItems];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (shouldReset) {
        shouldReset = NO;
        [self resetItems];
    }
}

- (void) setupItems {
    mainTabItem = [[TabBarItemModel alloc] init];
    mainTabItem.title = @"Main";
    mainTabItem.image = [UIImage imageNamed:@"Home icon"];
    mainTabItem.controller = [[ViewController alloc] init];
    
    menuTabItem1 = [[TabBarItemModel alloc] init];
    menuTabItem1.image = [UIImage imageNamed:@"List icon"];
    menuTabItem1.action = ^{
        // TODO: - action
    };
    
    menuTabItem2 = [[TabBarItemModel alloc] init];
    menuTabItem2.title = @"Big Menu";
    menuTabItem2.image = [UIImage imageNamed:@"List icon"];
    menuTabItem2.action = ^{
        // TODO: - action
    };
    
    menuTabItem3 = [[TabBarItemModel alloc] init];
    menuTabItem3.title = @"Bigger Menu";
    menuTabItem3.action = ^{
        // TODO: - action
    };
    
    menuTabItem4 = [[TabBarItemModel alloc] init];
    menuTabItem4.title = @"Biggest Menu";
    menuTabItem4.image = [UIImage imageNamed:@"List icon"];
    menuTabItem4.action = ^{
        // TODO: - action
    };
}

- (instancetype)instantiate {
    TabBarViewController* controller = [[TabBarViewController alloc] init];
    return controller;
}

- (void)resetItems {
    items = [@[mainTabItem, menuTabItem1, menuTabItem2, menuTabItem3, menuTabItem4] mutableCopy];
    NSMutableArray<UIViewController*>* controllers = [@[] mutableCopy];
    for (NSInteger i = 0; i < items.count; i++) {
        TabBarItemModel* model = items[i];
        
        if (model.cachedViewController) {
            [controllers insertObject:model.cachedViewController atIndex:controllers.count];
            continue;
        }
        
        UIViewController* controller;
        if (model.controller) {
            controller = model.controller;
        } else {
            controller = [[UIViewController alloc] init];
        }
        controller = [[UINavigationController alloc] initWithRootViewController:controller];
        
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:model.title image:model.image tag:i];
        if (!model.title) {
            CGFloat offset = 10;
            [item setImageInsets:UIEdgeInsetsMake(offset / 2, 0, -offset / 2, 0)];
        }
        
        item.titlePositionAdjustment = UIOffsetMake(0, -1);
        [controller setTabBarItem:item];
        
        [controllers insertObject:controller atIndex:[controllers count]];
    }
    [self setViewControllers:controllers];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index && index < [items count]) {
        TabBarItemModel* item = [items objectAtIndex:index];
        if (item.controller) {
            [self setSelectedIndex:index];
            return true;
        } else if (item.action) {
            item.action();
            return false;
        }
    }
    return true;
}

@end
