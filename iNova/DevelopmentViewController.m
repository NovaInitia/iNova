//
//  ProductionViewController.m
//  iNova
//
//  Created by Kyle Hughes on 3/31/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "DevelopmentViewController.h"
#import "WebSpaceViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MenuViewController.h"
#import "NI_API.h"

@interface DevelopmentViewController ()

@end

@implementation DevelopmentViewController

@synthesize registerButton = _registerButton;
@synthesize loginButton = _loginButton;
@synthesize webSpaceButton = _webSpaceButton;

/**
    UTILITY METHODS
 **/

- (IBAction) switchToProperController:(id)sender
{
    NSString* nibName;
    NSString* title;
    UIViewController* viewController;
    
    if(sender == self.registerButton)
    {
        nibName = [AppDelegate determineNib:@"RegisterViewController"];
        viewController = [[RegisterViewController alloc] initWithNibName:nibName bundle:nil];
        title = @"Register";
    }
    else if(sender == self.loginButton)
    {
        nibName = [AppDelegate determineNib:@"LoginViewController"];
        viewController = [[LoginViewController alloc] initWithNibName:nibName bundle:nil];
        title = @"Login";
    }
    else if(sender == self.webSpaceButton)
    {
        nibName = [AppDelegate determineNib:@"WebSpaceViewController"];
        viewController = [[WebSpaceViewController alloc] initWithNibName:nibName bundle:nil];
        title = @"Browser";
    }
    
    [viewController setTitle:title];
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
    ADMINISTRATION
 **/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.registerButton = nil;
    self.loginButton = nil;
    self.webSpaceButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
    SETUP FUNCTIONS
 */

- (void) setupButtons
{
    [self.registerButton addTarget:self action:@selector(switchToProperController:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(switchToProperController:) forControlEvents:UIControlEventTouchUpInside];
    [self.webSpaceButton addTarget:self action:@selector(switchToProperController:) forControlEvents:UIControlEventTouchUpInside];
}

@end
