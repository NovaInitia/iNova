//
//  DoorwaysOnLocationViewControllerViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/21/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "DoorwaysOnLocationViewController.h"
#import "Location.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@interface DoorwaysOnLocationViewController ()

@end

@implementation DoorwaysOnLocationViewController

@synthesize openButton = _openButton;

NSInteger numberOfRows;

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
    
    self.navigationItem.rightBarButtonItem = self.openButton;
}

- (void)viewDidUnload
{
    self.openButton = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
    UITableView DATA SOURCE
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numberOfRows = [Location sharedInstance].contents.doorways.count;
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Doorway* doorway =[[Location sharedInstance].contents.doorways objectAtIndex:indexPath.row];
    NSString* nsfwString = doorway.nsfw ? @"(NSFW)" : @"";
    
    NSString* apostrophe = ([doorway.user characterAtIndex:doorway.user.length - 1] == 's') ? @"'" : @"'s";
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@ Doorway %@", doorway.user, apostrophe, nsfwString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hint: %@", doorway.hint];
    
    return cell;
}

/*
    ACTION METHODS
 */

- (void) openDoorway
{
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    if (selectedIndexPath != nil)
    {
        // DO ANY SERVERSIDE CODE FOR OPENING A DOOR (IF THERE IS ANY)
        
        Doorway* doorway = [[Location sharedInstance].contents.doorways objectAtIndex:selectedIndexPath.row];
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        [Location sharedInstance].precedingDoorway = doorway; // For the rating of doorways after the fact
        [Location sharedInstance].canRateDoorway = YES; // ^^
        [appDelegate loadURLFromString:doorway.url];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"No Doorway Selected"
                              message: @"Please select a Doorway from the list, or use the back button."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


/*
    UITableView DELEGATE
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
    SETUP
 */

- (void) setupButtons
{
    self.openButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStyleDone target:self action:@selector(openDoorway)];
}

@end
