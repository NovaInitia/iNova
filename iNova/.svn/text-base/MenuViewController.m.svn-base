//
//  MenuViewController.m
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

/**
    THIS CLASS IS CONCEPTUALLY A SINGLETON.
    DON'T INSTANTIATE
 **/

#import "MenuViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "ModelUpdateEvent.h"
#import "NI_API.h"
#import "DoorwaysOnLocationViewController.h"
#import "SignpostsOnLocationViewController.h"
#import "Location.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "WebSpaceViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize placedToolsMenuTitles = _placedToolsMenuTitles, inventoryMenuTitles = _inventoryMenuTitles, menuMenuTitles = _menuMenuTitles, toolCell = _toolCell, generalCell = _generalCell, revealed = _revealed, sectionView = _sectionView;

static MenuViewController* instance;

static const NSUInteger NUMBER_OF_SECTIONS = 3;

UIColor* shieldOff;
UIColor* shieldOn;

/*
    ADMINISTRATION
 */

+ (MenuViewController*) sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            NSString* nibName = [AppDelegate determineNib:@"MenuViewController"];
            instance = [[MenuViewController alloc] initWithNibName:nibName bundle:nil];
        }
    }
    
    return(instance);
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.revealed = NO;
        [[User sharedInstance] subscribe:self]; // Subscribe to User's updates
        [[Location sharedInstance] subscribe:self]; // Subscribe to Location's updates
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:0.1953125 green:0.22265625 blue:0.2890625 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    shieldOff = [UIColor colorWithRed:1 green:0 blue:0 alpha:.6];
    shieldOn = [UIColor colorWithRed:0 green:1 blue:0 alpha:.6];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.placedToolsMenuTitles = nil;
    self.inventoryMenuTitles = nil;
    self.menuMenuTitles = nil;
    self.toolCell = nil;
    self.generalCell = nil;
    self.sectionView = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
    ACTION METHODS
 */

- (void) logout
{
    [[Location sharedInstance] unsubscribe:self];
    [instance viewDidUnload];
    instance = nil;
}

- (void) openBarrel
{
    // Attempt to open the barrel
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Prying open barrel...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        BOOL didOpen = [[Location sharedInstance] openBarrelOnLocation];
        
        if (didOpen)
        {
            // Get barrel
            Barrel* barrel = [Location sharedInstance].contents.barrel;
            
            // Delete barrel row and reference for Location
            [Location sharedInstance].contents.barrel = nil;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:PLACED_TOOLS]] withRowAnimation:NO];
            
            // Change item count (hacky as all hell)
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            WebSpaceViewController* webSpace = [[appDelegate.navigationController viewControllers] objectAtIndex:appDelegate.navigationController.viewControllers.count - 1];
            int itemCount = [Location sharedInstance].contents.doorways.count + [Location sharedInstance].contents.signposts.count;
            webSpace.itemCount.text = [NSString stringWithFormat:@"%i", itemCount];
            
            // Sync user info
            [[User sharedInstance] syncInformationWithServer];
            
            NSString* message = [NSString stringWithFormat:@"You managed to open the barrel from %@. Here are your spoils:\n\nSg: %i\nTraps: %i\nBarrels: %i\nSpiders: %i\nShields: %i\nDoorways: %i\nSignposts: %i", barrel.username, barrel.sg, barrel.traps, barrel.barrels, barrel.spiders, barrel.shields, barrel.doorways, barrel.signposts];
            
            // Alert user of result
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Success!"
                                  message: message
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            // Alert user of result
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Shucks!"
                                  message: @"That barrel just wouldn't open; maybe you should hit the gym more."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];

        }
        
        // Hide the progress hud since we're done               
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void) toggleShield
{
    // Attempt to toggle the shield
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Toggling shield...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        //Get response
        NSString* response = [[NI_API sharedInstance] send_request:@"http://data.nova-initia.com/rf/remog/user/shield.json" method:@"POST" parameters:@""];
        
        // Handle response
        SBJsonParser* parser = [[SBJsonParser alloc] init];
        NSDictionary* data = [parser objectWithString:response];

        id user = [data objectForKey:@"user"]; // Present if successfull
        
        if (user)
        {
            [[User sharedInstance] loadFromJSONString:response];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle: @"Client Error"
                                  message: @"Something went totally haywire when attempting to toggle your shield. Try again later."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // Hide the progress hud since we're done               
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

/*
    TABLEVIEWCONTROLLER DATA SOURCE STUFF
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) 
    {
        case PLACED_TOOLS:
            [self generatePlacedToolsMenuTitles];
            return self.placedToolsMenuTitles.count;
        case INVENTORY:
            [self generateInventoryMenuTitles];
            return self.inventoryMenuTitles.count;
        case MENU:
            [self generateMenuMenuTitles];
            return self.menuMenuTitles.count;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == PLACED_TOOLS || indexPath.section == INVENTORY)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ToolCell"];
        if(cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"MenuToolTableViewCell" owner:self options:nil];
            cell = self.toolCell;
            self.toolCell = nil;
        }
        
        UILabel* toolLabel = (UILabel*)[cell viewWithTag:1];
        
        UILabel* countLabel = (UILabel*)[cell viewWithTag:2];
        [countLabel.layer setCornerRadius:11];
        countLabel.backgroundColor = [UIColor colorWithRed:0.28515625 green:0.30859375 blue:0.37890625 alpha:1];
        countLabel.hidden = NO;
        
        // Placed Tools Section
        if(indexPath.section == PLACED_TOOLS)
        {
            toolLabel.text = [self.placedToolsMenuTitles objectAtIndex:indexPath.row];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString* cellTitle = [self.placedToolsMenuTitles objectAtIndex:indexPath.row];
            
            if ([cellTitle isEqualToString:@"Barrel"])
                countLabel.hidden = YES;
            else if ([cellTitle isEqualToString:@"Doorways"])
                countLabel.text = [NSString stringWithFormat:@"%i", [Location sharedInstance].contents.doorways.count];
            else if ([cellTitle isEqualToString:@"Signposts"])
                countLabel.text = [NSString stringWithFormat:@"%i", [Location sharedInstance].contents.signposts.count];
        }
        
        // Inventory Section 
        if(indexPath.section == INVENTORY)
        {
            toolLabel.text = [self.inventoryMenuTitles objectAtIndex:indexPath.row];
            
            
            [cell setSelectionStyle:UITableViewCellEditingStyleNone];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            switch (indexPath.row) 
            {
                case 0: // Barrels
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.numBarrels];
                    break;
                case 1: // Doorways
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.numDoors];
                    break;
                case 2: // Shield
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.numShields];
                    countLabel.backgroundColor = ([User sharedInstance].shield || [User sharedInstance].class == Guardian) ? shieldOn : shieldOff;
                    if ([User sharedInstance].inventory.numShields > 0)
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    }
                    break;
                case 3: // Signposts
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.numSignposts];
                    break;
                case 4: // Spiders
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.numSpiders];
                    break;
                case 5: // Traps
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.numTraps];
                    break;
                case 6: // Sg
                    countLabel.text = [NSString stringWithFormat:@"%i", [User sharedInstance].inventory.sg];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    break;
                default:
                    break;
            }
        }
    }
    else if (indexPath.section == MENU) 
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralCell"];
        if(cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"MenuGeneralTableViewCell" owner:self options:nil];
            cell = self.generalCell;
            self.generalCell = nil;
        }
        
        UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
        
        titleLabel.text = [self.menuMenuTitles objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBG.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBG_selected.png"]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    [[NSBundle mainBundle] loadNibNamed:@"MenuSectionView" owner:self options:nil];
    UIView* view = self.sectionView;
    self.sectionView = nil;
    
    NSString* title;
    
    switch (section) 
    {
        case PLACED_TOOLS:
            title = @"TOOLS ON PAGE";
            break;
        case INVENTORY:
            title = @"INVENTORY";
            break;
        case MENU:
            title = @"MENU";
            break;
        default:
            break;
    }
    
    UILabel* titleLabel = (UILabel*)[view viewWithTag:1];
    titleLabel.text = title;
    
    view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cellSectionBG.png"]];
    
    return view;
}

/*
    TABLEVIEWCONTROLLER DELEGATE STUFF
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == PLACED_TOOLS)
    {
        NSString* nibName;
        UIViewController* viewController;
        
        NSString* cellTitle = [self.placedToolsMenuTitles objectAtIndex:indexPath.row];
        
        if ([cellTitle isEqualToString:@"Barrel"])
            [self openBarrel];
        else 
        {
            if ([cellTitle isEqualToString:@"Doorways"])
            {
                nibName = [AppDelegate determineNib:@"DoorwaysOnLocationViewController"];
                viewController = [[DoorwaysOnLocationViewController alloc] initWithNibName:nibName bundle:nil];
                viewController.title = @"Doorways";
            }
            else if ([cellTitle isEqualToString:@"Signposts"])
            {
                nibName = [AppDelegate determineNib:@"SignpostsOnLocationViewController"];
                viewController = [[SignpostsOnLocationViewController alloc] initWithNibName:nibName bundle:nil];
                viewController.title = @"Signposts";
            }
            
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate.navigationController pushViewController:viewController animated:NO];
            
            [self toggleRevealed];
        }
    }
    else if (indexPath.section == INVENTORY)
    {
        if (indexPath.row == 2 && [User sharedInstance].inventory.numShields > 0) // SHIELD
        {
            [self toggleShield];
        }
        else if (indexPath.row == 6) // SG
        {
            NSString* tradePostURL = [NSString stringWithFormat:@"http://www.nova-initia.com/remog/trade?LASTKEY=%@", [NI_API sharedInstance].lastKey];
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate loadURLFromString:tradePostURL];
            [self toggleRevealed];
        }
    }
    else if(indexPath.section == MENU)
    {
        if (indexPath.row == 3) // LOGOUT
        {
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate logout];
        }
        else // The ones that just take you to a URL
        {
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            NSString* url;
            
            switch (indexPath.row) 
            {
                case 0: // PROFILE
                    url = [NSString stringWithFormat:@"http://www.nova-initia.com/remog/user/%@", [User sharedInstance].username];
                    break;
                case 1: // MESSAGES
                    url = [NSString stringWithFormat:@"http://www.nova-initia.com/remog/mail?LASTKEY=%@", [NI_API sharedInstance].lastKey];
                    break;
                case 2: // EVENTS
                    url = [NSString stringWithFormat:@"http://www.nova-initia.com/remog/events?LASTKEY=%@", [NI_API sharedInstance].lastKey];
                    break;
                default:
                    break;
            }
            
            [appDelegate loadURLFromString:url];
            [self toggleRevealed];                                                                                               
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
    SUBSCRIBING
 */

- (void) notify:(ModelUpdateEvent)event
{
    NSMutableIndexSet* indexSet;
    
    // Only respond to events we care about
    switch (event) 
    {
        case ModelUpdateEventUser:
            indexSet = [NSMutableIndexSet indexSetWithIndex:INVENTORY];
            break;
        case ModelUpdateEventLocation:
            indexSet = [NSMutableIndexSet indexSetWithIndex:PLACED_TOOLS];
            break;
        default:
            break;
    }
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

/*
    REVEALING
 */

- (void) toggleRevealed
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    CGRect destination = appDelegate.navigationController.view.frame;
    
    if (self.revealed) {
        destination.origin.x = 0;
    } else {
        destination.origin.x -= (320 - [AppDelegate MENU_DELTA]);
    }
    
    [UIView animateWithDuration:0.3 
            delay:0 
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^
            {
                appDelegate.navigationController.view.frame = destination;        
            }  
            completion:^(BOOL finished) 
            {
                appDelegate.webView.userInteractionEnabled = !self.revealed;
            }
     ];
    
    self.revealed = !self.revealed;
}

/*
    SETUP METHODS
 */

// The best part is that there's no reason for these methods, but they're here to be ROBUST!
- (void) generatePlacedToolsMenuTitles
{
    NSMutableArray* titles = [[NSMutableArray alloc] init];
    
    if ([Location sharedInstance].contents.barrel)
        [titles addObject:@"Barrel"];
    if ([Location sharedInstance].contents.doorways.count > 0)
        [titles addObject:@"Doorways"];
    if ([Location sharedInstance].contents.signposts.count > 0)
        [titles addObject:@"Signposts"];
    
    self.placedToolsMenuTitles = titles;
}

- (void) generateInventoryMenuTitles
{
    self.inventoryMenuTitles = [[NSMutableArray alloc] initWithObjects:@"Barrels", @"Doorways", @"Shield", @"Signposts", @"Spiders", @"Traps", @"Sg", nil];
}

- (void) generateMenuMenuTitles // I FREAKING CRACK MYSELF UP LOOK AT THIS IT'S HILARIOUS RIGHT?!
{
    self.menuMenuTitles = [[NSMutableArray alloc] initWithObjects:@"Profile", @"Messages", @"Events", @"Logout", nil];
}
                                   
    

@end
