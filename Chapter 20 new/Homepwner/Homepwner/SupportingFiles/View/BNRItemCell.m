//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Qian on 6/17/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self updateInterfaceForDynamicType];
    
    // listen for user text size settings
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark target action

- (IBAction)showImage:(id)sender {
    if (self.didTapThumbnailActionBlock) {
        self.didTapThumbnailActionBlock();
    }
}

#pragma mark Dynamic type

- (void)updateInterfaceForDynamicType {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
}



@end
