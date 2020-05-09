//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Qian on 5/4/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "HypnosisView.h"

@interface HypnosisView ()

@property (nonatomic, strong) UIColor *circleColor;

@end

@implementation HypnosisView

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 Drawing code
 }
 */

@synthesize circleColor = _circleColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIColor *)circleColor {
    if (!_circleColor) {
        _circleColor = [UIColor lightGrayColor];
    }
    return _circleColor;
}

-(void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius // Note this is currentRadius!
                    startAngle:0.0 endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    // configure the line to 10 pt
    path.lineWidth = 10;
    
    // circle color, everytime user touches the view, the color changes
    [self.circleColor setStroke];
    
    // Draw the line!
    [path stroke];
}

#pragma mark touch event handler, the view will be invoked with
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch action");
    // get 3 random number
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.circleColor = randColor;
}


@end
