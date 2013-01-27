//
//  DoorwaysOnLocationViewControllerViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/21/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoorwaysOnLocationViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UIBarButtonItem* openButton;

- (void) openDoorway;

- (void) setupButtons;

@end
