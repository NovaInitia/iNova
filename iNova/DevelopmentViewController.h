//
//  ProductionViewController.h
//  iNova
//
//  Created by Kyle Hughes on 3/31/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationDirection.h"

@interface DevelopmentViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton* registerButton;
@property (nonatomic, retain) IBOutlet UIButton* loginButton;
@property (nonatomic, retain) IBOutlet UIButton* webSpaceButton;

- (IBAction) switchToProperController:(id)sender;

- (void) setupButtons;

@end
