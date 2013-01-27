//
//  SignpostsOnLocationViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/26/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignpostsOnLocationViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UIBarButtonItem* openButton;

- (void) openSignpost;

- (void) setupButtons;

@end
