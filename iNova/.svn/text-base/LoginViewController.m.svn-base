//
//  LoginViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "LoginViewController.h"
#import "NI_API.h"
#import "User.h"
#import "WebSpaceViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize textCell = _textCell, saveLoginCell = _saveInfoCell, username = _username, password = _password, loginButton = _loginButton, registerButton = _registerButton;

static const NSInteger NUMBER_OF_ROWS = 3;

/*
    ADMINISTRATION
 */

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupButtons];
    
    self.navigationItem.rightBarButtonItem = self.loginButton;
    self.navigationItem.leftBarButtonItem = self.registerButton;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.username = nil;
    self.password = nil;
    self.loginButton = nil;
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

- (void) submitLogin
{   
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    
    // NEED TO CHECK TO MAKE SURE THEY ENTER VALUES!!!!!
    
    NSString* username = self.username.text;
    NSString* password = self.password.text;
    BOOL saveLogin = (self.saveLoginCell.accessoryType == UITableViewCellAccessoryCheckmark);
    
    // SAVING USER INFO
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (saveLogin)
    {
        [defaults setObject:username forKey:@"username"];
        [defaults setObject:password forKey:@"password"];
    }
    else 
    {
        [defaults setObject:@"" forKey:@"username"];
        [defaults setObject:@"" forKey:@"password"];
    }
    [defaults setBool:saveLogin forKey:@"saveLogin"];
    
    // LOGIN PROCESS
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Logging in...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
        NSString* jsonString = [[NI_API sharedInstance] login:self.username.text :self.password.text];
        if ([jsonString isEqualToString:@"Error: Login Incorrect "])
        {
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Login Incorrect"
                                  message: @"The login information you entered was incorrect.\n\nIf you do not have an account, choose the 'Register' button.\n\nOtherwise, please try again."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else if(jsonString.length > 23)
        {
            [[User sharedInstance] loadFromJSONString:jsonString];
            NSString* nibName = [AppDelegate determineNib:@"WebSpaceViewController"];
            UIViewController* viewController = [[WebSpaceViewController alloc] initWithNibName:nibName bundle:nil];
            [viewController setTitle:@"Browser"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Connection Error"
                                  message: @"Sorry, there was an error connecting to the server. Please try again."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void) goToRegister
{
    NSString* nibName = [AppDelegate determineNib:@"RegisterViewController"];
    UIViewController* registerVC = [[RegisterViewController alloc] initWithNibName:nibName bundle:nil];
    registerVC.title = @"Register";
    [self.navigationController pushViewController:registerVC animated:YES];
}

/*
    UITableView Data Source Stuff
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if(indexPath.row < 2) // FIELDS
    {
        CellIdentifier = @"TextCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"TextTableViewCell" owner:self options:nil];
            cell = self.textCell;
            self.textCell = nil;
        }
        
        UILabel* title = (UILabel*)[cell.contentView viewWithTag:1];
        
        UITextField* textField = (UITextField*)[cell.contentView viewWithTag:2];
        textField.delegate = self;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.secureTextEntry = NO;
        textField.placeholder = @"";
        
        switch (indexPath.row) 
        {
            case 0:
                title.text = @"Username";
                textField.text = [defaults objectForKey:@"username"];
                self.username = textField;
                break;
            case 1:
                title.text = @"Password";
                textField.secureTextEntry = YES;
                textField.text = [defaults objectForKey:@"password"];
                self.password = textField;
                break;
        }
    }
    else // CHECKBOXES
    {
        CellIdentifier = @"CheckCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString* title;
        BOOL checked;
        
        switch (indexPath.row) 
        {
            case 2:
                title = @"Save Login Info?";
                checked = [defaults boolForKey:@"saveLogin"];
                cell.accessoryType = checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }

        cell.textLabel.text = title;
        
        self.saveLoginCell = cell;
    }
    
    return cell;
}


/*
    SETUP METHODS
 */

- (void) setupButtons
{
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(submitLogin)];
    self.registerButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(goToRegister)];
}

/*
 TEXTFIELD DELEGATE STUFF
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 1) // Checkboxes
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryNone) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}


@end
