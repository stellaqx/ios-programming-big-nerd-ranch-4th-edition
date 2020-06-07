//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Qian on 5/11/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "BNRItemsViewController.h"

#import "BNRItem.h"
#import "BNRItemStore.h"

#import "BNRDetailViewController.h"

@interface BNRItemsViewController () <UITableViewDelegate,
                                      UITableViewDataSource>
                                      

@end

@implementation BNRItemsViewController

// designated initializer
- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        //        for (int i = 0; i < 5; i++) {
        //            [[BNRItemStore sharedStore] createItem];
        //        }
        // setting nav bar title
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        
        // nav bar item
        // Create a new bar button item that will send
        // addNewItem: to BNRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register, so give control to Apple,and tell them hey the table view, we use this kind of cell, and it should instantitate if no cell in reuse pool
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UITabvleViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore sharedStore] allItems] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // re-use
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // set content for cell text label view
    NSArray *allItems = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = allItems[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}

// deleting items - If the table view is asking to commit a delete command...
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems]; BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

// moving items
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (IBAction)addNewItem:(UIButton *)sender {
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    // Create a detail view controller to update the item
    BNRDetailViewController *detailViewController =
    [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    // a completion block is like a call back
    typeof(self) __weak weakSelf = self;
    detailViewController.dismissBlock = ^{
        [weakSelf.tableView reloadData];
    };
    
    // Create a navigation controller, and init with with the detail view controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    // Update the style
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    // Present the detail view controller
    [self presentViewController:navController animated:YES completion: NULL];
}

#pragma mark navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController =
    [[BNRDetailViewController alloc] initForNewItem:NO];
    
    // passing data between vcs
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    // Give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

@end
