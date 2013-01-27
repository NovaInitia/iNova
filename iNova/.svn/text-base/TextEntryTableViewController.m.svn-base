//
//  TextEntryTableViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/16/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

/*
    NOTE: Only meant to be extended by other UITableViewControllers
 */

#import "TextEntryTableViewController.h"

@interface TextEntryTableViewController ()

@end

@implementation TextEntryTableViewController

@synthesize cancelButton = _cancelButton;

/*
    ADMINISTRATION
 */

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupKeyboardNotifications];
    [self setupButtons];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.cancelButton = nil;
}

/*
 KEYBOARD NOTIFICATION STUFF
 */

- (void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else 
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else 
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    [UIView commitAnimations];
}

/*
    ACTION METHODS
 */

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 SETUP STUFF
 */

// Need to be able to scroll Table View to show the currently selected textfield.
- (void) setupKeyboardNotifications
{
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) setupButtons
{
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:self.cancelButton];
}


@end
