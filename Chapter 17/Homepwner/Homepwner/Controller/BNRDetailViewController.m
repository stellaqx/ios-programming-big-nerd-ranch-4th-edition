//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRDetailViewController.h"

#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate,
                                       UIImagePickerControllerDelegate,
                                       UITextFieldDelegate,
                                       UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *BNRItemView;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (strong, nonatomic) UIPopoverController *imagePickerPopOver;

@end

@implementation BNRDetailViewController

- (instancetype) initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelBtn;
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneBtn;
    }
    return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    [NSException raise:@"Wrong initializer" format:@"Use initForNewItem:"];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *itemView = self.BNRItemView;
    self.view = itemView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation uiInterfaceOrientation = self.interfaceOrientation;
    [self prepareViewsForOrientation:uiInterfaceOrientation];
    
    BNRItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    // You need an NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.itemKey;
    // Get the image for its image key from the image store
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    // Use that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Clear first responder [self.view endEditing:YES];
    // "Save" changes to item
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

#pragma mark property related

- (void)setItem:(BNRItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (UIView *)BNRItemView {
    if (!_BNRItemView) {
        [[NSBundle mainBundle] loadNibNamed:@"BNRItem" owner:self options:nil];
    }
    return _BNRItemView;
}

#pragma mark target-action

- (IBAction)takePicture:(id)sender {
    // fix a bug when the popover controller is visible and user taps the camera button again...
    // because when a new popover is visible, and we are creating a new popover (using a new imagePicker) by tapping camera button, and it makes the visible one destroyed (we only have one reference to it)
    if ([self.imagePickerPopOver isPopoverVisible]) {
        // safely get rid of it by calling dismiss
        [self.imagePickerPopOver dismissPopoverAnimated:YES];
        self.imagePickerPopOver = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    // check for iPad before instantiating, if is Ipad, we will popover controller to present the image picker on screen
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // create a new pop over controller that will display the image picker
        self.imagePickerPopOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopOver.delegate = self;
        
        // display the popover controller, sender is the image button
        [self.imagePickerPopOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
// save the image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    // Try to dismiss the controller
    // Do I have a popover controller?
    if (self.imagePickerPopOver) {
        [self.imagePickerPopOver dismissPopoverAnimated:YES];
        self.imagePickerPopOver = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark Device Orientation
- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation {
    // decide if this is an ipad; if so, we do not need to do anything for device orientation change preparation.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // if in iPhone landscape, disable the camera button
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"User dismissed popover");
    self.imagePickerPopOver = nil;
}

#pragma mark target-action on UIBarButtonItem cancel: save:

- (void)save:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender {
    [[BNRItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
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
