//
//  Location.m
//  iNova
//
//  Created by Kyle Hughes on 4/13/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "Location.h"
#import "ModelUpdateEvent.h"
#import "Trap.h"
#import "Barrel.h"
#import "Spider.h"
#import "Doorway.h"
#import "Signpost.h"
#import "SBJson.h"
#import "NI_API.h"
#import "User.h"

@implementation Location

@synthesize location = _location, contents = _contents, precedingDoorway = _precedingDoorway, canRateDoorway = _canRateDoorway, fubar = _fubar;

static Location* instance;

NSMutableDictionary* userIDsAsUsernames;

+ (Location*) sharedInstance
{
    @synchronized(self)
    {
        if (instance == nil) 
        {
            instance = [[Location alloc] init];
            userIDsAsUsernames = [[NSMutableDictionary alloc] init];
        }
    }
    return(instance);
}

- (void) loadContentsFromJSON:(NSString *)json
{
    Trap* trap;
    Spider* spider;
    Barrel* barrel;
    NSMutableArray* doorways = [[NSMutableArray alloc] init];
    NSMutableArray* signposts = [[NSMutableArray alloc] init];
    
    // Handle response
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSDictionary* data = [parser objectWithString:json];
    
    self.fubar = NO;
    
    NSLog(json);
    
    @try
    {
    
        NSArray* pageSet = [data objectForKey:@"pageSet"];
        id jsonTrap = [pageSet objectAtIndex:0];
        id jsonBarrel = [pageSet objectAtIndex:1];
        NSArray* jsonDoorways = [pageSet objectAtIndex:4];
        
        // Trap Loading
        if ([jsonTrap JSONRepresentation].length > 3)
        {
            int trapID = [(NSString*)[jsonTrap objectForKey:@"ID"] integerValue];
            int userID = [(NSString*)[jsonTrap objectForKey:@"USERID"] integerValue];
            NSString* trapUsername = [self getUsernameForUserID:userID];
            trap = [[Trap alloc] initWithID:trapID username:trapUsername];
            
            [[User sharedInstance] syncInformationWithServer];
        }
    
        // Barrel Loading (ya, there's only one)
        if ([jsonBarrel JSONRepresentation].length > 3)
        {
            int barrelID = [(NSString*)[jsonBarrel objectForKey:@"ID"] integerValue];
            int userID = [(NSString*)[jsonBarrel objectForKey:@"USERID"] integerValue];
            NSString* barrelUsername = [self getUsernameForUserID:userID];
            barrel = [[Barrel alloc] initWithID:barrelID username:barrelUsername];
        }
        
        // Doorway Loading
        for(id doorway in jsonDoorways)
        {
            int doorID = [(NSString*)[doorway objectForKey:@"ID"] integerValue];
            int userID = [(NSString*)[doorway objectForKey:@"USERID"] integerValue];
   
            NSString* username = [self getUsernameForUserID:userID];
            
            NSArray* doorInfo = [self getDoorInfoForDoorID:doorID];
            NSString* url = [doorInfo objectAtIndex:0];
            NSString* comment = [doorInfo objectAtIndex:1];
            //BOOL nsfw = [[doorInfo objectAtIndex:2] boolValue];
            
            id toolData = [doorway objectForKey:@"toolData"];
            NSString* hint = [toolData objectForKey:@"Hint"];
            
            Doorway* door = [[Doorway alloc] initWithID:doorID user:username url:url hint:hint comment:comment nsfw:NO];
            
            [doorways addObject:door];
        }
    }
    @catch (NSException* ex)
    {
        self.fubar = YES;
        
        trap = nil;
        barrel = nil;
        doorways = [[NSMutableArray alloc] init];
        signposts = [[NSMutableArray alloc] init];
        
        // Alert user of result
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops!"
                              message: @"Seems like your internet connection kicked the bucket while loading the page. Refresh and try again."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    // Signpost loading
    /*
    Signpost* sign = [[Signpost alloc] initWithID:1 user:@"David" title:@"Revolutionary War" comment:@"Lolz, just trollin' bra" nsfw:YES];
    [signposts addObject:sign];
    sign = [[Signpost alloc] initWithID:2 user:@"Fisher" title:@"Restaurant Running" comment:@"Lolz, still trollin'" nsfw:YES];
    [signposts addObject:sign];*/
    
    // ALLOCATE NEW CONTENT OBJECT
    _contents = [[LocationContents alloc] initWithTrap:trap spider:spider barrel:barrel doorways:doorways signposts:signposts];
}

/*
    USER METHODS
 */

- (NSString*) getUsernameForUserID:(int)userID
{
    NSString* username;
    NSString* key = [NSString stringWithFormat:@"%i",userID];
    
    if (!(username = [userIDsAsUsernames objectForKey:key]))
    {
        // Get response
        NSString* requestURL = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/user/%i.json", userID];
        NSString* response = [[NI_API sharedInstance] send_request:requestURL method:@"GET" parameters:@""];
        
        // Handle response
        SBJsonParser* parser = [[SBJsonParser alloc] init];
        NSDictionary* data = [parser objectWithString:response];
        
        id user = [data objectForKey:@"user"];
        
        username = [user objectForKey:@"UserName"];
        [userIDsAsUsernames setValue:username forKey:key];
    }
    
    return (username) ? username : @"The Nameless One";
}

/*
    BARREL METHODS
 */

- (BOOL) openBarrelOnLocation
{
    if (!self.contents.barrel)
        return false;
    
    // Get response
    NSString* requestURL = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/gift/%i.json", self.contents.barrel.idNum];
    NSString* response = [[NI_API sharedInstance] send_request:requestURL method:@"GET" parameters:@""];
    
    // Handle response
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSDictionary* data = [parser objectWithString:response];
    
    id barrel = [data objectForKey:@"gift"];
    
    if (barrel)
    {
        // Get various pieces of data
        id jsonSg = [barrel objectForKey:@"Sg"];
        id jsonTraps = [barrel objectForKey:@"Tool0"];
        id jsonBarrels = [barrel objectForKey:@"Tool1"];
        id jsonSpiders = [barrel objectForKey:@"Tool2"];
        id jsonShields = [barrel objectForKey:@"Tool3"];
        id jsonDoorways = [barrel objectForKey:@"Tool4"];
        id jsonSignposts = [barrel objectForKey:@"Tool5"];
        id jsonMessage = [barrel objectForKey:@"Comment"];
        id jsonLabel = [barrel objectForKey:@"Title"];
        
        int sg = (jsonSg) ? [(NSString*)jsonSg integerValue] : 0;
        int traps = (jsonTraps) ? [(NSString*)jsonTraps integerValue] : 0;
        int barrels = (jsonBarrels) ? [(NSString*)jsonBarrels integerValue] : 0;
        int spiders = (jsonSpiders) ? [(NSString*)jsonSpiders integerValue] : 0;
        int shields = (jsonShields) ? [(NSString*)jsonShields integerValue] : 0;
        int doorways = (jsonDoorways) ? [(NSString*)jsonDoorways integerValue] : 0;
        int signposts = (jsonSignposts) ? [(NSString*)jsonSignposts integerValue] : 0;
        NSString* message = (jsonMessage) ? jsonMessage : @"N/A";
        NSString* label = (jsonLabel) ? jsonLabel : @"";
        
        [self.contents.barrel addContentsSg:sg traps:traps barrels:barrels spiders:spiders shields:shields doorways:doorways signposts:signposts message:message label:label];
        
        return true;
    }
    else 
    {
        return false;
    }
}
 

/*
    DOOR METHODS
 */

- (NSArray*) getDoorInfoForDoorID:(int)doorID
{
    // Get response
    NSString* requestURL = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/doorway/%i.json", doorID];
    NSString* response = [[NI_API sharedInstance] send_request:requestURL method:@"GET" parameters:@""];
    
    // Handle response
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSDictionary* data = [parser objectWithString:response];
    
    id doorway = [data objectForKey:@"doorway"];
    
    // Get various pieces of data
    NSString* doorURL = [doorway objectForKey:@"Url"];
    doorURL = (doorURL) ? doorURL : @"http://nova-initia.com";

    NSString* comment = [doorway objectForKey:@"Comment"];
    comment = (comment) ? comment : @"No comment provided.";
    
    NSNumber* nsfw = [doorway objectForKey:@"NSFW"];
    
    NSArray* doorInfo = [NSArray arrayWithObjects:doorURL, comment, nsfw, nil];
    
    return doorInfo;
}

                         
/*
    SETTERS
 */
- (void) setLocation:(NSString *)location
{
    _location = location;
    [self notifySubscribers:ModelUpdateEventLocation];
}

@end
