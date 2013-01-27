//
//  RateDoorwayViewController.h
//  iNova
//
//  Created by Kyle Hughes on 5/2/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateDoorwayViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* commentLabel;
@property (nonatomic, retain) IBOutlet UITextField* commentField;
@property (nonatomic, retain) IBOutlet UILabel* ratingLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl* ratingControl;

@property (nonatomic, retain) UIBarButtonItem* cancelButton;
@property (nonatomic, retain) UIBarButtonItem* doneButton;

- (void) rateDoorway;
- (void) cancel;

- (void) setupButtons;

@end
