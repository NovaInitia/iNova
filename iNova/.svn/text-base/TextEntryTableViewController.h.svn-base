//
//  TextEntryTableViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/16/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NI_API.h"
#import "AppDelegate.h"

@interface TextEntryTableViewController : UITableViewController

@property (nonatomic, retain) UIBarButtonItem* cancelButton;

-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

- (void) cancel;

- (void) setupKeyboardNotifications;
- (void) setupButtons;

@end
