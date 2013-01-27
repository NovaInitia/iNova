//
//  Location.h
//  iNova
//
//  Created by Kyle Hughes on 4/13/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "Notifier.h"
#import "LocationContents.h"

@interface Location : Notifier

@property (nonatomic, retain, setter = setLocation:) NSString* location; // Either the URL or GPS coordinates
@property (nonatomic, retain) LocationContents* contents;
@property (nonatomic, retain) Doorway* precedingDoorway;

@property (nonatomic) BOOL canRateDoorway;
@property (nonatomic) BOOL fubar;

+ (Location*) sharedInstance;

- (void) loadContentsFromJSON:(NSString*)json;

- (NSString*) getUsernameForUserID:(int)userID;
- (BOOL) openBarrelOnLocation;
- (NSArray*) getDoorInfoForDoorID:(int)doorID;

- (void) setLocation:(NSString *)location;

@end
