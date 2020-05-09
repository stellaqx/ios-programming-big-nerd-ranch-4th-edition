//
//  BNRReminderViewController.m
//  Hypnosister
//
//  Created by Qian on 5/8/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRReminderViewController.h"

#import <UserNotifications/UserNotifications.h>

@interface BNRReminderViewController () <UNUserNotificationCenterDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

@end

@implementation BNRReminderViewController

// designated view controller initializer
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // the title of tab bar item
        self.tabBarItem.title = @"Remind";
        
        // add an image
        self.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:60]];
    
    [self.datePicker setDate:[NSDate date]];
}

- (IBAction)addReminder:(UIButton *)sender {
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // Enable or disable features based on authorization.
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications]; // you can also set here for local notification.
    
    // NSLocalNotification
    NSDate *remindDate = self.datePicker.date;
    //    UILocalNotification *remindNotification = [[UILocalNotification alloc] init];
    //    remindNotification.alertBody = @"Hypnotize me";
    //    remindNotification.fireDate = remindDate;
    // schedule send
    //    [[UIApplication sharedApplication] scheduleLocalNotification:remindNotification];
    
    // 1. content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Hello!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Hello_message_body"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 2. date component
    // https://stackoverflow.com/questions/43405959/launch-a-local-notification-at-a-specific-time-in-ios
    // and you do not need paid membership for local notification
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear +
                                       NSCalendarUnitMonth + NSCalendarUnitDay +
                                       NSCalendarUnitHour + NSCalendarUnitMinute +
                                       NSCalendarUnitSecond fromDate:remindDate];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponent repeats:NO];
    //UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10
    //repeats:NO];
    NSLog(@"Setting reminder time: %@", dateComponent);
    
    // 3. request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"hypnosis" content:content trigger:trigger];
    
    // 4. add request
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        // adding
    }];
}

# pragma mark UNUserNotificationCenterDelegate
// override the willPresent: method to display notification in foreground mode
// @see https://www.techotopia.com/index.php/An_iOS_10_Local_Notification_Tutorial



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
