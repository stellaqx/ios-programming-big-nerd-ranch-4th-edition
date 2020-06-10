//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRItemStore.h"

#import "BNRItem.h"
#import "BNRImageStore.h"

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

- (void)removeItem:(BNRItem *)item {
    [self.privateItems removeObjectIdenticalTo:item];
    
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (fromIndex == toIndex) {
        return;
        
    }
    // Get pointer to object being moved so you can re-insert it
    BNRItem *item = self.privateItems[fromIndex];
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

- (BOOL) saveChanges {
    NSString *path = [self itemArchivePath];
    
    // return YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

#pragma mark private

- (instancetype)init {
    [NSException raise:@"Singleton" format:@"Use +[BNRItemStore sharedStore] instead"];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // if the path contains empty content, create the private item here separately
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init]; 
        }
    }
    return self;
}

- (NSArray<BNRItem *> *)allItems {
    return [self.privateItems copy];
}

#pragma mark data persisting

- (NSString *)itemArchivePath {
    // Make sure the first argument is NSDocumentDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get document directory
    NSString *documentDir = [documentDirectories firstObject];
    
    return [documentDir stringByAppendingPathComponent:@"item.archive"];
}

@end
