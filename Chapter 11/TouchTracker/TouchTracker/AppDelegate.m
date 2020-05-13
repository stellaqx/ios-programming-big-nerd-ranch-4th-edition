//
//  AppDelegate.m
//  TouchTracker
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRDrawViewController.h"

@interface AppDelegate () {
    UIWindow *_window;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [[BNRDrawViewController alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}


@end
