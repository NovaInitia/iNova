//
//  User.m
//  iNova
//
//  Created by Kyle Hughes on 4/4/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

/*
    MAKE SURE TO INITIALIZE THIS UPON LOGIN/VERIFICATION BECAUSE IT'S KINDA USELESS OTHERWISE LOLOLOLOLOL
 */ 

#import "User.h"
#import "SBJSON/SBJson.h"
#import "NI_API.h"

@interface User ()

@end

@implementation User

@synthesize idNum = _idNum, username = _username, class = _class, inventory = _inventory, exp = _exp, level = _level, shield = _shield;

static User* instance;

+ (User*) sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
            instance = [[User alloc] init];
    }
    
    return(instance);
}

- (id) init
{
    self = [super init];
    if(self)
    {
        _inventory = [[Inventory alloc] initWithBarrels:0 doors:0 sg:0 shields:0 signposts:0 spiders:0 traps:0];
        
        // Subscriptions
        [self.inventory subscribe:self];
    }
    
    return self;
}

- (void) syncInformationWithServer
{
    NSString* requestURL = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/user/%i.json", self.idNum];
    
    NSString* response = [[NI_API sharedInstance] send_request:requestURL method:@"GET" parameters:@""];
    
    [self loadFromJSONString:response];
}

- (void) loadFromJSONString:(NSString *)json
{
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSDictionary* data = [parser objectWithString:json];
    
    id user = [data objectForKey:@"user"];
    
    self.idNum = [(NSString*)[user objectForKey:@"ID"] intValue];
    self.username = [user objectForKey:@"UserName"];
    self.class = [(NSString*)[user objectForKey:@"Class"] intValue];
    
    switch (self.class) 
    {
        case Giver:
            self.level = [(NSString*)[user objectForKey:@"LevelClass1"] intValue];
            break;
        case Guardian:
            self.level = [(NSString*)[user objectForKey:@"LevelClass2"] intValue];
            break;
        case Guide:
            self.level = [(NSString*)[user objectForKey:@"LevelClass3"] intValue];
            break;
        default:
            self.level = -1; // No level in JSON for Refugee
            break;
    }
    
    self.inventory.numBarrels = [(NSString*)[user objectForKey:@"Tool1"] intValue];
    self.inventory.numDoors = [(NSString*)[user objectForKey:@"Tool4"] intValue];
    self.inventory.sg = [(NSString*)[user objectForKey:@"Sg"] intValue];
    self.inventory.numShields = [(NSString*)[user objectForKey:@"Tool3"] intValue];
    self.inventory.numSignposts = [(NSString*)[user objectForKey:@"Tool5"] intValue];
    self.inventory.numSpiders = [(NSString*)[user objectForKey:@"Tool2"] intValue];
    self.inventory.numTraps = [(NSString*)[user objectForKey:@"Tool0"] intValue];
    
    self.shield = [((NSString*)[user objectForKey:@"isShielded"]) isEqualToString:@"1"];
}

// THIS METHOD PROBABLY SHOULDN'T BE CALLED OUTSIDE OF APPDELEGATE
- (void) logout
{
    [self.inventory unsubscribe:self];
    
    self.username = nil;
    self.inventory = nil;
    
    instance = nil;
}

/*
    SUBSCRIBED NOTIFICATION HANDLING
 */

- (void) notify:(ModelUpdateEvent)event
{
    // Only respond to events we care about
    switch (event) 
    {
        case ModelUpdateEventInventory:
            [self notifySubscribers:ModelUpdateEventUser];
            break;
        default:
            break;
    }
}

/*
    MANUAL SETTERS
    Done for to be able to notify subscribers
 */

- (void) setClass:(PlayerClass)class
{
    _class = class;
    [self notifySubscribers:ModelUpdateEventUser];
}

- (void) setExp:(int)exp
{
    _exp = exp;
    [self notifySubscribers:ModelUpdateEventUser];
}

- (void) setLevel:(int)level
{
    _level = level;
    [self notifySubscribers:ModelUpdateEventUser];
}

- (void) setShield:(BOOL)shield
{
    _shield = shield;
    [self notifySubscribers:ModelUpdateEventUser];
}

@end
