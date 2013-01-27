//
//  SignpostsOnLocationViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/26/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "SignpostsOnLocationViewController.h"
#import "Location.h"
#import "Signpost.h"

@interface SignpostsOnLocationViewController ()

@end

@implementation SignpostsOnLocationViewController

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
    numberOfRows = [Location sharedInstance].contents.signposts.count;
    
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
    
    Signpost* signpost =[[Location sharedInstance].contents.signposts objectAtIndex:indexPath.row];
    NSString* nsfwString = signpost.nsfw ? @"(NSFW)" : @"";
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", signpost.title, nsfwString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"From: %@", signpost.user];
    
    return cell;
}

/*
 UITableView DELEGATE
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
 ACTION METHODS
 */

- (void) openSignpost
{
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    if (selectedIndexPath != nil)
    {
        // DO ANY SERVERSIDE CODE FOR OPENING A DOOR (IF THERE IS ANY)
    }
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"No Signpost Selected"
                              message: @"Please select a Signpost from the list, or use the back button."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


/*
 SETUP
 */

- (void) setupButtons
{
    self.openButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStyleDone target:self action:@selector(openSignpost)];
}

@end
