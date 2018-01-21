//
//  ActionsList
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [self loadScreen];
    return YES;
}

- (UIWindow*)loadScreen {
    UIWindow* window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    TabBarViewController* root = [[TabBarViewController alloc] instantiate];
    [window setRootViewController:root];
    [window makeKeyAndVisible];
    return window;
}

@end
