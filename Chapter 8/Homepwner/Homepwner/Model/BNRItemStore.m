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
    
    return item;
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
    }
    return self;
}

- (NSArray<BNRItem *> *)allItems {
    return [self.privateItems copy];
}

@end
