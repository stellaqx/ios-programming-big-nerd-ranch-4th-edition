//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Qian on 6/17/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // we should cast the view back to UIImageView so that compiler
    // no warning about setImage
    UIImageView *view = (UIImageView *)self.view;
    [view setImage:self.image];
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
