//
//  RateDoorwayViewController.m
//  iNova
//
//  Created by Kyle Hughes on 5/2/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "RateDoorwayViewController.h"
#import "Location.h"
#import "WebSpaceViewController.h"

@interface RateDoorwayViewController ()

@end

@implementation RateDoorwayViewController

@synthesize commentLabel = _commentLabel, commentField = _commentField, ratingLabel = _ratingLabel, ratingControl = _ratingControl, cancelButton = _cancelButton, doneButton = _doneButton;

/*
    ADMINISTRATION
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup
    [self setupButtons];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // Label Styling
    self.commentLabel.backgroundColor = [UIColor clearColor];
    self.commentLabel.font = [UIFont boldSystemFontOfSize:16];
    self.commentLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.commentLabel.shadowOffset = CGSizeMake(1,1);
    self.commentLabel.textColor = [UIColor colorWithRed:(76.0f/255.0f) green:(86.0f/255.0f) blue:(108.0f/255.0f) alpha:1.0f];
    
    self.ratingLabel.backgroundColor = [UIColor clearColor];
    self.ratingLabel.font = [UIFont boldSystemFontOfSize:16];
    self.ratingLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.ratingLabel.shadowOffset = CGSizeMake(1,1);
    self.ratingLabel.textColor = [UIColor colorWithRed:(76.0f/255.0f) green:(86.0f/255.0f) blue:(108.0f/255.0f) alpha:1.0f];
    
    // Place comment into comment area
    self.commentField.text = [Location sharedInstance].precedingDoorway.comment;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.commentLabel = nil;
    self.commentField = nil;
    self.ratingLabel = nil;
    self.ratingControl = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
    ACTION METHODS
 */

- (void) rateDoorway
{
    [((WebSpaceViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]) toggleRate];
    // CODE FOR SENDING THE DOORWAY-RATING COMMENT AND RATING TO THE SERVER
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
    TEXTFIELD DELEGATE STUFF
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

/*
    SETUP
 */

- (void) setupButtons
{
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:self.cancelButton];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rateDoorway)];
    [self.navigationItem setRightBarButtonItem:self.doneButton];
}

@end
