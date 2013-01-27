//
//  PlaceSignpostViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/16/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryTableViewController.h"

@interface PlaceSignpostViewController : TextEntryTableViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableViewCell* textCell;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* doneButton;

@property (nonatomic, retain) UITextField* titleField;
@property (nonatomic, retain) UITextField* commentField;
@property (nonatomic, retain) UITableViewCell* nsfwCell;

- (void) placeSignpost;

@end
