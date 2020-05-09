//
//  BNRHyposisViewController.m
//  Hypnosister
//
//  Created by Qian on 5/8/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRHyposisViewController.h"
#import "HypnosisView.h"

@interface BNRHyposisViewController ()

@end

@implementation BNRHyposisViewController

// designated view controller initializer
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // the title of tab bar item
        self.tabBarItem.title = @"Hypnotize";
        
        // add an image
         self.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    }
    return self;
}

// load view creates the view programatically; without the XIB file
- (void)loadView {
    // createa a view
    CGRect frame = [UIScreen mainScreen].bounds;
    HypnosisView *hypnosisView = [[HypnosisView alloc] initWithFrame:frame];
    
    // set it as the "view" of this vc
    self.view = hypnosisView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    // create the CGRects for frames
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect bigRect = screenRect;
    // bigRect.size.width *= 2.0;
    //bigRect.size.height *= 2.0;
    CGRect ori = CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.width, screenRect.size.height);
    ori.origin.x -= screenRect.size.width * 0.5;
    
    // create a screen-sized scroll view and add it to the window
    NSLog(@"%@", NSStringFromCGRect(ori));

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    // create a super-sized hyposis view and add it to the scroll view
    HypnosisView *hypnosisView = [[HypnosisView alloc] initWithFrame:ori];
    [scrollView addSubview:hypnosisView];
    
    ori.origin.x += screenRect.size.width;
    
    NSLog(@"%@", NSStringFromCGRect(ori));
    HypnosisView *anotherView = [[HypnosisView alloc] initWithFrame:ori];
    [scrollView addSubview:anotherView];
    
    // tell the scroll view, how big its content area is
    scrollView.contentSize = bigRect.size;
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
