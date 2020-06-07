//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class BNRItem;

@interface BNRDetailViewController : UIViewController

- (instancetype) initForNewItem:(BOOL)isNew;
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, strong) void (^dismissBlock)(void);
@end

NS_ASSUME_NONNULL_END
