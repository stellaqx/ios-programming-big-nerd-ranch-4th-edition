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
@property (nonatomic, strong) BNRItem *item;
@end

NS_ASSUME_NONNULL_END
