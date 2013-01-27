//
//  LoginViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryTableViewController.h"

@interface LoginViewController : TextEntryTableViewController <UITextFieldDelegate>

@property (nonatomic, retain) UITableViewCell* textCell;

@property (nonatomic, retain) UITableViewCell* saveLoginCell;

@property (nonatomic, retain) UITextField* username;
@property (nonatomic, retain) UITextField* password;

@property (nonatomic, retain) UIBarButtonItem* loginButton;
@property (nonatomic, retain) UIBarButtonItem* registerButton;

- (void) submitLogin;
- (void) goToRegister;

@end
