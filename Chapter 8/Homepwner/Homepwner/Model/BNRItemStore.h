//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BNRItem;

@interface BNRItemStore : NSObject

// 1.property
@property (readonly, nonatomic, copy) NSArray<BNRItem *> *allItems;

// 2. singleton / init
+ (instancetype)sharedStore;

// 3. utility methods
- (BNRItem *)createItem;

@end

NS_ASSUME_NONNULL_END
