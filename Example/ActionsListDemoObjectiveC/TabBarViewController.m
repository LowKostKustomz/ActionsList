//
//  ActionsList
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewController.h"

@interface TabBarItemModel : NSObject

@property (nonatomic, strong, nullable) NSString* title;
@property (nonatomic, strong, nullable) UIImage* image;
@property (nonatomic, copy, nullable) void (^action)(TabBarItemModel*);
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
    ActionsListModel* list;
}

- (instancetype)instantiate {
    TabBarViewController* controller = [[TabBarViewController alloc] init];
    return controller;
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
    
    __weak TabBarViewController* weakSelf = self;
    
    menuTabItem1 = [[TabBarItemModel alloc] init];
    menuTabItem1.image = [UIImage imageNamed:@"List icon"];
    menuTabItem1.action = ^(TabBarItemModel* model) {
        [weakSelf showMenuForModel:model];
    };
    
    menuTabItem2 = [[TabBarItemModel alloc] init];
    menuTabItem2.title = @"Big Menu";
    menuTabItem2.image = [UIImage imageNamed:@"List icon"];
    menuTabItem2.action = ^(TabBarItemModel* model) {
        [weakSelf showMenuForModel:model];
    };
    
    menuTabItem3 = [[TabBarItemModel alloc] init];
    menuTabItem3.title = @"Bigger Menu";
    menuTabItem3.action = ^(TabBarItemModel* model) {
        [weakSelf showMenuForModel:model];
    };
    
    menuTabItem4 = [[TabBarItemModel alloc] init];
    menuTabItem4.title = @"Biggest Menu";
    menuTabItem4.image = [UIImage imageNamed:@"List icon"];
    menuTabItem4.action = ^(TabBarItemModel* model) {
        [weakSelf showMenuForModel:model];
    };
}

- (void)showMenuForModel:(TabBarItemModel*)model {
    if (model.controller) {
        if (model.controller.tabBarItem) {
            [self showMenuForItem:model.controller.tabBarItem model:model];
        }
    }
}

- (void)showMenuForItem:(UITabBarItem*)item model:(TabBarItemModel*)model {
    ActionsListModel* internalList = [item createActionsListWithDelegate:self];
    [internalList setupDismissAccessibilityHint:@"Double tap to dismiss"];
    NSString* title = model.title;
    
    if ([title isEqualToString:@"Big Menu"]) {
        [self addActions:4 toList:internalList];
    } else if ([title isEqualToString:@"Bigger Menu"]) {
        [self addActions:8 toList:internalList];
    } else if ([title isEqualToString:@"Biggest Menu"]) {
        [self addActions:16 toList:internalList];
    } else {
        [self addActions:2 toList:internalList];
    }
    
    [internalList presentWithCompletion:NULL];
    list = internalList;
}

- (void)addActions:(NSInteger)count toList:(ActionsListModel*)list {
    for (NSInteger i = 1; i <= count; i++) {
        NSMutableString* title = [@"" mutableCopy];
        
        for (NSInteger j = 0; j < i; j++) {
            [title appendString:[NSString stringWithFormat:@"Action number %ld", (long)i]];
            
            if (j != i - 1) {
                [title appendString:@"\n"];
            }
        }
        ActionsListDefaultButtonModel* actionModel = [[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:title
                                                                                                             image:[UIImage imageNamed:@"Dot"] action:^(ActionsListDefaultButtonModel* action) {
                                                                                                                 [action.list dismissWithCompletion:NULL];
                                                                                                             } isEnabled:YES];
        [actionModel setupAccessibilityWithAccessibilityLabel:[NSString stringWithFormat:@"%ld tests", (long)i]];
        [list addAction:actionModel];
    }
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
        model.controller = controller;
        
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

- (void)actionsListDidHide {
    if (@available(iOS 11, *)) {
        [self.tabBar setTintColor:self.tabBar.unselectedItemTintColor];
    }
}

- (void)actionsListWillShow {
    [self.tabBar setTintColor:self.view.window.tintColor];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index && index < [items count]) {
        TabBarItemModel* item = [items objectAtIndex:index];
        if (item.cachedViewController) {
            [self setSelectedIndex:index];
            return true;
        } else if (item.action) {
            item.action(item);
            return false;
        }
    }
    return true;
}

@end
