//
//  BNRItem.m
//  RandomItems
//

#import "BNRItem.h"

#import <Foundation/Foundation.h>

@implementation BNRItem

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _itemKey = [coder decodeObjectForKey:@"itemKey"];
        _serialNumber = [coder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [coder decodeObjectForKey:@"dateCreated"];
        _valueInDollars = [coder decodeIntForKey:@"valueInDollars"];
        _thumbnail = [coder decodeObjectForKey:@"thumbnail"];
    }
    return self;
}

+ (instancetype)randomItem
{
    // Create an immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    // Create an immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10, 'A' + arc4random() % 26, '0' + arc4random() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollar:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollar:0 serialNumber:@""];
}

- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollar:0 serialNumber:sNumber];
}

- (instancetype)initWithItemName:(NSString *)name
                   valueInDollar:(int)value
                    serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designaed initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        // Set _datedCreated to the current date and time
        _dateCreated = [[NSDate alloc] init];
        
        // Create an NSUUID object - and get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (void)setThumbnail:(UIImage *)image {
    // takeas a full sized image, and creates a smaller size version of it.
    // iOS provides function UIGraphicsBeginImageContextWithOption, that takes in a CGSize
    // specifying hte width and height of the image context, scaling factor, and whether it should be opaque
    // Then, a new CGContext Ref is created, and becomes the current context
    // to get the UIImage out fromthe newly created context, we call UIGraphicsGetImageFromCurrentImageContext
    
    CGSize origImageSize = image.size;
    
    // we need to create a 40 by 40 rectangle for thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // we can calculate the scaling factor, by dividing the orig and desired w / h
    float r1 = newRect.size.width / origImageSize.width;
    float r2 = newRect.size.height / origImageSize.height;
    float ratio;
    // center the image in the thumnail rec
    CGRect projectRect;
    
    if (r1 < r2) {
        ratio = r1;
        projectRect.size.width = newRect.size.width;
        projectRect.size.height = ratio * origImageSize.height;
    } else {
        ratio = r2;
        projectRect.size.width = ratio * origImageSize.width;
        projectRect.size.height = newRect.size.height;
    }
    
    float x = ( newRect.size.width -projectRect.size.width ) / 2.0;
    projectRect.origin.x = x > 0.0 ? x : 0.0;
    float y = (newRect.size.height - projectRect.size.height) / 2.0;
    projectRect.origin.y = y > 0.0 ? y : 0.0;
    
    // create a transparent bitmap context with a scaling factor, equals to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0);
    
    // Create a path which is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5];
    
    // making all subsequent drawing clip to the rounded rec
    [path addClip];
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // get the image from the image context, and keep it as thumbnail in the item object
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    _thumbnail = smallImage;
    
    // clean up the image context, when done
    UIGraphicsEndImageContext();
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth %d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];

    return descriptionString;

}

# pragma mark NSCoder
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.itemName forKey:@"itemName"];
    [coder encodeObject:self.itemKey forKey:@"itemKey"];
    [coder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [coder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [coder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

@end

