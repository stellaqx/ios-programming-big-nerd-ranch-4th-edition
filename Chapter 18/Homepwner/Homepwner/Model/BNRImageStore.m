//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

+ (instancetype)sharedStore {
    static BNRImageStore *sharedInstance;
    // singleton, thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
    
    // we are going to create a buffer to copy the image.
    // In obj C, we use NSData
    
    // create a string representing the path
    NSString *imagePath = [self imagePathForKey:key];
    
    // convert UIImage to jpeg represent NSData
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // write the data to full image path
    [data writeToFile:imagePath atomically:YES];
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    // if possible, get it from the dictionary
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // create an UIImage object by reading from file system
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // if we found it, put it in the dictionary (cache)
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find: %@", imagePath);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    // also make sure we have remove from the file system
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

#pragma mark private
- (instancetype) init {
    //[NSException raise:@"Singletone" format:@"Please use +[BNRImageStore sharedInstance] instead."];
    @throw [NSException exceptionWithName:@"Singleton" reason:@"use +[BNRImageStore sharedInstance]" userInfo:nil];
    return nil;
}

- (instancetype) initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
