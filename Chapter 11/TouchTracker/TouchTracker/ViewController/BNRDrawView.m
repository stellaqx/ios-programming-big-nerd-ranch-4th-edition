//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView ()

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame: (CGRect)r {
    self = [super initWithFrame: r];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;// enable multiple touches
    }
    return self;
}

- (NSMutableArray *)finishedLines {
    if (!_finishedLines) {
        _finishedLines = [[NSMutableArray alloc] init];
    }
    return _finishedLines;
}

- (NSMutableDictionary *)linesInProgress {
    if (!_linesInProgress) {
        _linesInProgress = [[NSMutableDictionary alloc] init];
    }
    return _linesInProgress;
}

#pragma mark drawing
- (void)strokeLine:(BNRLine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint: line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect {
   [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

#pragma mark handle touch events and turn them into lines
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    for (UITouch *t  in touches) {
        CGPoint location = [t locationInView:self];
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t  in touches) {
    CGPoint location = [t locationInView:self];
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        line.end = location;
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }

    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
// Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
    NSValue *key = [NSValue valueWithNonretainedObject:t]; [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

@end
