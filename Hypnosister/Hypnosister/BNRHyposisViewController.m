//
//  BNRHyposisViewController.m
//  Hypnosister
//
//  Created by Qian on 5/8/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRHyposisViewController.h"
#import "HypnosisView.h"

@interface BNRHyposisViewController () <UITextFieldDelegate>

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
    
    CGRect textFieldRect = CGRectMake(40, 70, 320, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    // Setting the border style on the text field will allow us to see it more easily
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [hypnosisView addSubview:textField];
    // customizing the keyboard, the return key now says "Done" instead of "Return"
    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;
    
    // makes this view controller responding to the textfield related method
    textField.delegate = self;
    
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

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    
    [self drawHypnoticMessage:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

#pragma mark private

- (void)drawHypnoticMessage:(NSString *)message {
    for (int i = 0; i < 20; i++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        // Configure the label's colors and text
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        // This method resizes the label, which will be relative
        // to the text that it is displaying
        [messageLabel sizeToFit];
        // Get a random x value that fits within the hypnosis view's width
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        // Get a random y value that fits within the hypnosis view's height
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        // Update the label's frame
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        // Add the label to the hierarchy
        [self.view addSubview:messageLabel]; }
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
