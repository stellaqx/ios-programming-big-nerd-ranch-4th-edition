//
//  AppDelegate.m
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"

@interface AppDelegate () {
    UIWindow *_window;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    BNRItemsViewController *itemsVC = [[BNRItemsViewController alloc] init];
    
    // place the itemsVC's view into window view hierachy by making it the rootVC
    self.window.rootViewController = itemsVC;
    
    // boilder plate
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

# pragma mark private
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

@end
