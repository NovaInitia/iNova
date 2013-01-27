//
//  PlaceTrapViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/16/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "PlaceTrapViewController.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "User.h"

@interface PlaceTrapViewController ()

@end

@implementation PlaceTrapViewController

@synthesize textCell = _textCell, doneButton = _doneButton, messageField = _messageField;

static const NSInteger NUMBER_OF_ROWS = 2;

/*
 ADMINISTRATION
 */

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupButtons];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.textCell = nil;
    self.doneButton = nil;
    self.messageField = nil;
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

- (void) placeTrap
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    // Get the current URL the trap is being placed on
    NSString* onURL = [[[appDelegate.webView request] URL] absoluteString];

    // Attempt to place the trap, handle the result, and display progress hud while doing it
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Setting trap...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        // Send request and get response
        NSString* response = [[NI_API sharedInstance] placeTrapOn:onURL withMessage:@"" anonymous:nil];
        
        // Handle response
        SBJsonParser* parser = [[SBJsonParser alloc] init];
        NSDictionary* data = [parser objectWithString:response];
        
        id failure = [data objectForKey:@"fail"]; // Present upon placement failure
        id pageSet = [data objectForKey:@"pageSet"]; // Present upon placement success
        id result = [data objectForKey:@"result"]; // Present upon page full-ness / spider blow-up-ness
        
        if (failure)
        {
            // Sync user inventory information
            [[User sharedInstance] syncInformationWithServer];
            
            // Alert user of result
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops!"
                                  message: @"You tried to set a trap, but you failed and your trap was destroyed. Better luck next time!"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            // Get out of this view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (pageSet)
        {
            // Sync user inventory information
            [[User sharedInstance] syncInformationWithServer];
            
            // Alert user of result
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Success!"
                                  message: @"Your trap was set on the page.\n\nNote: if you refresh the page, you'll spring your own trap. Be careful!"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            // Get out of this view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (result)
        {
            if (((NSString*)result) == @"Page Full")
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Page Full"
                                      message: @"Sorry, the page has reached its item capacity. Try again later."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                
                // Get out of this view controller
                [self.navigationController popViewControllerAnimated:YES];
            }
            else // Spider blew up the trap
            {
                // Sync user inventory information
                [[User sharedInstance] syncInformationWithServer];
                
                // Alert user of result
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Boom!"
                                      message: @"A spider on the page blew up your trap in your face! That's gotta hurt."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                
                // Get out of this view controller
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else 
        {
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Client Error"
                                  message: @"Something went totally haywire when attempting to set your trap. Try again later."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            // Get out of this view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        // Hide the progress hud since we're done               
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
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
    
    if(indexPath.row < 1) // FIELDS
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
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        textField.placeholder = @"";
        
        switch (indexPath.row) 
        {
            case 0:
                title.text = @"Message";
                self.messageField = textField;
                break;
            default:
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
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = @"Anonymous?";
        
        cell.userInteractionEnabled = [User sharedInstance].level >= 10;
    }
    
    return cell;
}

/*
 UITextViewDelegate STUFF
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 0) // Checkboxes
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryNone) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/*
 SETUP STUFF
 */

- (void) setupButtons
{
    [super setupButtons];
    
    [self.doneButton setTarget:self];
    [self.doneButton setAction:@selector(placeTrap)];
}

@end
