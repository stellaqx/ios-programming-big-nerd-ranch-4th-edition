//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRItemStore.h"

#import "BNRItem.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray<BNRItem *> *privateItems;

@property (nonatomic) NSMutableArray<BNRItem *> *privateCheapItems;
@property (nonatomic) NSMutableArray<BNRItem *> *privateExpensiveItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore {
    // a static variable is not destroyed when the object is dealloc
    static BNRItemStore *sharedInstance;
    
    if (!sharedInstance) {
        sharedInstance = [[BNRItemStore alloc] initPrivate];
    }
    
    return sharedInstance;
}

- (BNRItem *)createItem {
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    
    if (item.valueInDollars < 50) {
        [self.privateCheapItems addObject:item];
    } else {
        [self.privateExpensiveItems addObject:item];
    }
    
    return item;
}

#pragma mark bonze challenge - section

- (NSInteger)numberOfSections {
    // be careful regarding @2 and 2
    return 2;
}

- (NSString *)titleForSection:(int)section {
     if (section == 0) {
          return @"Cheap Items -value less than $50";
      } else if (section == 1) {
          return @"Expensive Items -value more than $50";
      } else {
          return @"";
      }
}

- (NSArray *)allItemsInSection:(int)section {
    if (section == 0) {
        return [self.privateCheapItems copy];
    }
    else if (section == 1) {
        return [self.privateExpensiveItems copy];
    } else {
        return @[];
    }
}

#pragma mark private

- (instancetype)init {
    [NSException raise:@"Singleton" format:@"Use +[BNRItemStore sharedStore] instead"];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
        _privateCheapItems = [[NSMutableArray alloc] init];
        _privateExpensiveItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray<BNRItem *> *)allItems {
    return [self.privateItems copy];
}

@end
