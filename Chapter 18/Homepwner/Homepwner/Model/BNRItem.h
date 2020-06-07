  //
//  BNRItem.h
//  RandomItems
//
//  Created by Stella on 11/20/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject <NSCoding>

@property (readwrite, copy, nonatomic) NSString *itemName;
@property (readwrite, copy, nonatomic) NSString *serialNumber;
@property (readwrite, assign, nonatomic) int valueInDollars;
@property (readonly, strong, nonatomic) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;

+ (instancetype)randomItem;

// Designated initializer for BNRItem
- (instancetype)initWithItemName:(NSString *)name
                   valueInDollar:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;

@end
