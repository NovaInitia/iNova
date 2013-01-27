//
//  RegisterViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize registerWebView = _registerWebView;

/*
    ADMINISTRATION
 */

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
    
    NSURL* registerURL = [NSURL URLWithString:@"http://www.nova-initia.com/remog/user/profile"];
    NSURLRequest* request = [NSURLRequest requestWithURL:registerURL];
    [self.registerWebView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.registerWebView = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationItem setPrompt:@"Use the 'New Account Registration' area."];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
