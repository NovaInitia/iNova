//
//  PlaceBarrelViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/15/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "PlaceBarrelViewController.h"
#import "User.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "PlayerClass.h"

@interface PlaceBarrelViewController ()

@end

@implementation PlaceBarrelViewController

@synthesize textCell = _textCell, doneButton = _doneButton, sgField = _sgField, trapsField = _trapsField, barrelsField = _barrelsField, spidersField = _spidersField, shieldsField = _shieldsField, doorwaysField = _doorwaysField, signpostsField = _signpostsField, messageField = _messageField, labelField = _labelField;

static const NSInteger NUMBER_OF_ROWS = 9;

NSMutableArray* textfieldValues;

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
    
    textfieldValues = [[NSMutableArray alloc]initWithObjects: [NSString stringWithFormat:@""], [NSString stringWithFormat:@""], [NSString stringWithFormat:@""],[NSString stringWithFormat:@""], [NSString stringWithFormat:@""], [NSString stringWithFormat:@""],[NSString stringWithFormat:@""], [NSString stringWithFormat:@""],[NSString stringWithFormat:@""],nil];
    
    [self setupButtons];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.textCell = nil;
    self.doneButton = nil;
    self.sgField = nil;
    self.trapsField = nil;
    self.barrelsField = nil;
    self.spidersField = nil;
    self.doorwaysField = nil;
    self.signpostsField = nil;
    self.messageField = nil;
    self.labelField = nil;
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

- (void) placeBarrel
{
    // Get all of the various values for the parameters
    int sg = [self.sgField.text integerValue];
    int traps = [self.trapsField.text integerValue];
    int barrels = [self.barrelsField.text integerValue];
    int spiders = [self.spidersField.text integerValue];
    int shields = [self.shieldsField.text integerValue];
    int doorways = [self.doorwaysField.text integerValue];
    int signposts = [self.signpostsField.text integerValue];
    
    // Determine item limit
    int limit = ([User sharedInstance].class == Giver) ? 100 : 10;
    
    // Perform basic pre-placement check (item limit, empty barrel) and if passing place the freaking barrel!
    if ((sg/10) + traps + barrels + spiders + doorways + signposts > limit)
    {
        // Alert user of result
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"Not So Fast"
                              message: [NSString stringWithFormat:@"You went over your barrel item-limit of %i. Cut back on a few things and try again.\n\nNote: the limit for Givers is 100, and everyone else 10.",limit]
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];

    }
    else if (sg == 0 && traps == 0 && barrels == 0 && spiders == 0 && shields == 0 && doorways == 0 && signposts == 0)
    {
        // Alert user of result
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"No Empty Barrels"
                              message: @"Sorry, but you're not allowed to stash empty barrels. Throw a few items in there and try again."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else // All systems go, place that barrel!
    {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        // Setup the rest of the parameters
        NSString* url = [[[appDelegate.webView request] URL] absoluteString];
        NSString* message = (self.messageField.text) ? self.messageField.text : @"";
        NSString* label = (self.labelField.text) ? self.labelField.text : @"";
        
        // Attempt to leave the barrel, handle the result, and display progress hud while doing it
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Leaving barrel...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            // Send request and get response
            NSString* response = [[NI_API sharedInstance] placeBarrelOn:url sg:sg traps:traps barrels:barrels spiders:spiders shields:shields doorways:doorways signposts:signposts message:message label:label];
            
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
                                      message: @"You tried to leave a barrel, but you failed and your barrel was destroyed. \nBetter luck next time!"
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
                                      message: @"Your barrel was left on the page."
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
                if ([((NSString*)error) isEqualToString:@"low inventory"])
                {
                    UIAlertView* alert = [[UIAlertView alloc]
                                          initWithTitle: @"Low Inventory"
                                          message: @"Looks like you don't have enough of the items that you're trying to stash. \nPare back on some things and try again."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if([((NSString*)error) isEqualToString:@"Barrel Over Capacity"])
                {
                    UIAlertView* alert = [[UIAlertView alloc]
                                          initWithTitle: @"Barrel Over Capacity"
                                          message: @"Looks like you tried to stash more than your barrel could handle. \nRemember, if you're not a Giver, you can only stash one type of item."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                else 
                {
                    UIAlertView* alert = [[UIAlertView alloc]
                                          initWithTitle: @"Server Error"
                                          message: @"It seems there was an error stashing your barrel; sorry about that. Try again."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle: @"Client Error"
                                      message: @"Something went totally haywire when attempting to leave your barrel. Try again later."
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TextTableViewCell" owner:self options:nil];
        cell = self.textCell;
        self.textCell = nil;
        UITextField* textField = (UITextField*)[cell.contentView viewWithTag:2];
        [textField setTag:4 + indexPath.row];
    }
    
    UILabel* title = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel* extraLabel = (UILabel*)[cell.contentView viewWithTag:3];
    
    UITextField* textField = (UITextField*)[cell.contentView viewWithTag:4 + indexPath.row];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.enabled = YES;
    
    PlayerClass class = [User sharedInstance].class;
    int level = [User sharedInstance].level;
    
    switch (indexPath.row) 
    {
        case 0:
            title.text = @"Sg";
            textField.enabled = (class == Giver);
            self.sgField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.sg];
            break;
        case 1:
            title.text = @"Traps";
            self.trapsField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.numTraps];
            break;
        case 2:
            title.text = @"Barrels";
            self.barrelsField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.numBarrels];
            break;
        case 3:
            title.text = @"Spiders";
            self.spidersField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.numSpiders];
            break;
        case 4:
            title.text = @"Shields";
            self.shieldsField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.numShields];
            break;
        case 5:
            title.text = @"Doorways";
            self.doorwaysField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.numDoors];
            break;
        case 6:
            title.text = @"Signposts";
            self.signpostsField = textField;
            extraLabel.text = [NSString stringWithFormat:@"of %i", [User sharedInstance].inventory.numSignposts];
            break;
        case 7:
            title.text = @"Message";
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            self.messageField = textField;
            break;
        case 8:
            title.text = @"Label";
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.enabled = (class == Giver && level >= 5);
            self.labelField = textField;
            break;
        default:
            break;
    }
    
    textField.text = [textfieldValues objectAtIndex:indexPath.row];
    
    return cell;
}

/*
    UITextViewDelegate STUFF
 */


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textfieldValues replaceObjectAtIndex:textField.tag - 4 withObject:textField.text];
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textfieldValues replaceObjectAtIndex:textField.tag - 4 withObject:textField.text];
}


/*
 SETUP STUFF
 */

- (void) setupButtons
{
    [super setupButtons];
    
    [self.doneButton setTarget:self];
    [self.doneButton setAction:@selector(placeBarrel)];
}

@end
