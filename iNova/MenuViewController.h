//
//  MenuViewController.h
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuToolTableViewCell.h"
#import "Subscriber.h"

enum {
    PLACED_TOOLS = 0,
    INVENTORY,
    MENU
} typedef Sections;

@interface MenuViewController : UITableViewController <Subscriber>

@property (nonatomic, assign) IBOutlet UITableViewCell* toolCell;
@property (nonatomic, assign) IBOutlet UITableViewCell* generalCell;
@property (nonatomic, retain) IBOutlet UIView* sectionView;

@property (nonatomic, retain) NSMutableArray* placedToolsMenuTitles;
@property (nonatomic, retain) NSMutableArray* inventoryMenuTitles;
@property (nonatomic, retain) NSMutableArray* menuMenuTitles; // When you've written as much of this code as I have, this makes sense. -.-

@property (nonatomic) BOOL revealed;

+ (MenuViewController*) sharedInstance;

- (void) logout;
- (void) openBarrel;
- (void) toggleShield;

- (void) toggleRevealed;

- (void) generatePlacedToolsMenuTitles;
- (void) generateInventoryMenuTitles;

@end
