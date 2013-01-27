//
//  PlaceSignpostViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/16/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "PlaceSignpostViewController.h"
#import "User.h"
#import "SBJson.h"
#import "MBProgressHUD.h"

@interface PlaceSignpostViewController ()

@end

@implementation PlaceSignpostViewController

@synthesize textCell = _textCell, doneButton = _doneButton, titleField = _titleField, commentField = _commentField, nsfwCell = _nsfwCell;

static const NSInteger NUMBER_OF_ROWS = 3;

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
    self.titleField = nil;
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

- (void) placeSignpost
{
    if (self.titleField.text.length > 0)
    {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        // Setup all the parameters
        NSString* url = [[[appDelegate.webView request] URL] absoluteString];
        NSString* title = self.titleField.text;
        NSString* comment = (self.commentField.text) ? self.commentField.text : @"";
        BOOL nsfw = (self.nsfwCell.accessoryType == UITableViewCellAccessoryCheckmark);

        // Attempt to place the signpost, handle the result, and display progress hud while doing it
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Placing signpost...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            // Send request and get response
            NSString* response = [[NI_API sharedInstance] placeSignpostOn:url title:title comment:comment nsfw:nsfw]; 
            
            // Handle response
            SBJsonParser* parser = [[SBJsonParser alloc] init];
            NSDictionary* data = [parser objectWithString:response];
            
            id failure = [data objectForKey:@"fail"]; // Present upon placement failure
            id pageSet = [data objectForKey:@"pageSet"]; // Present upon placement success
            id result = [data objectForKey:@"result"]; // Present upon page full-ness / signpost-blocking (wtf)
            id error = [data objectForKey:@"error"]; // Present upon error placing
            
            if (failure)
            {
                // Sync user inventory information
                [[User sharedInstance] syncInformationWithServer];
                
                // Alert user of result
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Oops!"
                                      message: @"You tried to place a signpost, but you failed and your signpost was destroyed. Better luck next time!"
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
                                      message: @"Your signpost was placed on the page."
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
                else // Signpost was blocked...?
                {
                    // Sync user inventory information
                    [[User sharedInstance] syncInformationWithServer];
                    
                    // Alert user of result
                    UIAlertView* alert = [[UIAlertView alloc]
                                          initWithTitle: @"Blocked!"
                                          message: @"Your signpost was blocked! Unfortunately you lost it in the process."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    
                    // Get out of this view controller
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else if (error)
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Server Error"
                                      message: @"It seems there was an error placing your signpost; sorry about that. Try again later."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
            else 
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Client Error"
                                      message: @"Something went totally haywire when attempting to place your signpost. Try again later."
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
                              initWithTitle: @"No Title"
                              message: @"Please enter a title for your Signpost, or select the cancel button."
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
    UITableViewCell* cell;
    static NSString* CellIdentifier;
    
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
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        textField.placeholder = @"";
    
        switch (indexPath.row) 
        {
            case 0:
                title.text = @"Title";
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                self.titleField = textField;
                break;
            case 1:
                title.text = @"Comment";
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
        
        cell.textLabel.text = @"NSFW?";
        
        self.nsfwCell = cell;
    }
    
    return cell;
}

/*
 UITextViewDelegate STUFF
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
    [self.doneButton setAction:@selector(placeSignpost)];
}



@end
