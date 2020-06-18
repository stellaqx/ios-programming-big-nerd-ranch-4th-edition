//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by Qian on 6/18/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "AppDelegate.h"

#import "BNRCoursesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BNRCoursesViewController *coursesVC = [[BNRCoursesViewController alloc] init];
    
    // we will use a navigation controller as the root VC for the app window, and make coursesVC on top
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:coursesVC];
    
    self.window.rootViewController = rootNav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
