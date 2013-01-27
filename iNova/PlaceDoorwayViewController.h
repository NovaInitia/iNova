//
//  PlaceDoorwayViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/14/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryTableViewController.h"

@interface PlaceDoorwayViewController : TextEntryTableViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableViewCell* textCell;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* doneButton;

@property (nonatomic, retain) UITextField* urlField;
@property (nonatomic, retain) UITextField* hintField;
@property (nonatomic, retain) UITextField* commentField;
@property (nonatomic, retain) UITableViewCell* nsfwCell;

- (void) placeDoorway;

@end
