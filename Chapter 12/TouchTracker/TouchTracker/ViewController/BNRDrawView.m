//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView () <UIGestureRecognizerDelegate>

// move the line, pan gesture recognizer
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) BNRLine *selectedLine;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame: (CGRect)r {
    self = [super initWithFrame: r];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;// enable multiple touches
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;//prevent red dot
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;//prevent red dot
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer]; //
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        // pan gesture recognizer
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];

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

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [[UIBezierPath alloc] init];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect
{
    
    // for profiling purpose only
//    float f = 0.0;
//    for (int i = 0; i < 10000000; i++) {
//        f = f + sin(sin(sin(time(NULL) + i )));
//    }
//    NSLog(@"f = %f", f);
    
    // Draw finished lines in black
    [[UIColor blackColor] set];
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
       [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
}

- (BNRLine *)linetAtPoint:(CGPoint)p
{
    // Fina lne close to p
    for (BNRLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        // Check a few points on the line
        for (CGFloat t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    
    // If nothing is close enough to the tapped point,
    // then we did not select a line
    return nil;
}

#pragma mark - UIResponder (touch events)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
        
        line.containingArray = self.finishedLines;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

#pragma mark UIGestureRecognizer
- (void)doubleTap:(UIGestureRecognizer *)doubleTapRecognizer {
    NSLog(@"Double tap reconed");
    
    [self.linesInProgress removeAllObjects];
//    [self.finishedLines removeAllObjects];
    
    self.finishedLines = [[NSMutableArray alloc] init];
    
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr {
    NSLog(@"Single tap reconed");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self linetAtPoint:point];
    
    
    if (self.selectedLine) {
        // Make ourselves the target of menu item action messages
        [self becomeFirstResponder];
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // Create a new "Delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete"
                                                            action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        // Tell the menu where it should come from and show it
        [menu showMenuFromView:self rect:CGRectMake(point.x, point.y, 2, 2)];
    } else {
        // Hide the menu if no line is selected
        [[UIMenuController sharedMenuController] hideMenuFromView:self];
    }
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)deleteLine:(id)sender {
    // Remove the selected line from the list of _finishedLines
    [self.finishedLines removeObject:self.selectedLine];
    // Redraw everything
    [self setNeedsDisplay];
}

// long press
- (void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self linetAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    
    [self setNeedsDisplay];
}

#pragma mark UIGestureRecognizerDelegate
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

- (void)moveLine:(UIPanGestureRecognizer *)gr {
    if (!self.selectedLine) {
        // it means we cannot select a line here, basically nothing much to do (we need to move a selected line to designated location)
        return;
    }
    
    // when the pan recognizer changes the location
    if (gr.state == UIGestureRecognizerStateChanged) {
        // how far the pan has moved
        CGPoint translation = [gr translationInView:self];
        
        // add the translation to current beginning and end points of the line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        // set the new beginning and end of selected line, to reflect change
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        // redraw
        [self setNeedsDisplay];
        
        // clear pan gr reported change after the change has been applied
        [gr setTranslation:CGPointZero inView:self];
    }
}


@end
