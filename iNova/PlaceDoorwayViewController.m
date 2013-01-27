//
//  PlaceDoorwayViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/14/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "PlaceDoorwayViewController.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "User.h"

@interface PlaceDoorwayViewController ()

@end

@implementation PlaceDoorwayViewController

@synthesize textCell = _textCell, doneButton = _doneButton, urlField = _urlField, hintField = _hintField, commentField = _commentField, nsfwCell = _nsfwCell;

static const NSInteger NUMBER_OF_ROWS = 4;

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
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.textCell = nil;
    self.doneButton = nil;
    self.urlField = nil;
    self.hintField = nil;
    self.commentField = nil;
    self.nsfwCell = nil;
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

- (void) placeDoorway
{
    if (self.urlField.text.length > 0 && [self.urlField.text rangeOfString:@"."].length > 0) // Piss-poor checking
    {
        // Format the URL with protocol (if not there)
        NSURL* url = [NSURL URLWithString:self.urlField.text];
        if(!url.scheme)
        {
            NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", self.urlField.text];
            url = [NSURL URLWithString:modifiedURLString];
        }
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        // Setup all the parameters
        NSString* fromURL = [[[appDelegate.webView request] URL] absoluteString];
        NSString* toURL = [url absoluteString];
        NSString* hint = (self.hintField.text) ? self.hintField.text : @"";
        NSString* comment = (self.commentField.text) ? self.commentField.text : @"";
        BOOL nsfw = (self.nsfwCell.accessoryType == UITableViewCellAccessoryCheckmark);
        
        // Attempt to open the doorway, handle the result, and display progress hud while doing it
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Opening doorway...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            // Send request and get response
            NSString* response = [[NI_API sharedInstance] placeDoorwayFrom:fromURL to:toURL hint:hint comment:comment nsfw:nsfw];  
            
            // Handle response
            SBJsonParser* parser = [[SBJsonParser alloc] init];
            NSDictionary* data = [parser objectWithString:response];
            
            id failure = [data objectForKey:@"fail"]; // Present upon placement failure
            id pageSet = [data objectForKey:@"pageSet"]; // Present upon placement success
            id result = [data objectForKey:@"result"]; // Present upon page full-ness
            id error = [data objectForKey:@"error"]; // Present upon error placing
            
            if (failure)
            {
                // Sync user inventory information
                [[User sharedInstance] syncInformationWithServer];
                
                // Alert user of result
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Oops!"
                                      message: @"You tried to set a doorway, but you failed and your doorway was destroyed. Better luck next time!"
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
                                      message: @"Your doorway was opened on the page."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                
                // Get out of this view controller
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (result)
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
            else if (error)
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Server Error"
                                      message: @"It seems there was an error opening your doorway; sorry about that. Try again later."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
            else 
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Client Error"
                                      message: @"Something went totally haywire when attempting to open your doorway. Try again later."
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
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"Invalid URL"
                              message: @"Please enter a valid URL, or use the back button."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
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
    
    if(indexPath.row < 3) // FIELDS
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
                title.text = @"URL";
                textField.keyboardType = UIKeyboardTypeURL;
                textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                textField.autocorrectionType = UITextAutocorrectionTypeNo;
                self.urlField = textField;
                break;
            case 1:
                title.text = @"Hint";
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                self.hintField = textField;
                break;
            case 2:
                title.text = @"Comment";
                textField.placeholder = @"";
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                self.commentField = textField;
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
        
        NSString* title = @"NSFW?";
        cell.textLabel.text = title;
        
        self.nsfwCell = cell;
    }
    
    return cell;
}

/*
    UITextViewDelegate STUFF
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 2) // Checkboxes
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryNone) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
}


// Handle the "tabbing" through the TextFields
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    /*
        TABBING
    if(textField == self.urlField)
        [self.hintField becomeFirstResponder];
    else if(textField == self.hintField)
        [self.commentField becomeFirstResponder];
    else if(textField == self.commentField)
        [self placeDoorway]; // Some checks need to be done to make sure everything is filled in
     */
    
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
    [self.doneButton setAction:@selector(placeDoorway)];
}

@end
