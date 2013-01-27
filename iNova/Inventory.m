//
//  Inventory.m
//  iNova
//
//  Created by Kyle Hughes on 4/4/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

/**
    NOTE: As of now (4/6/2012), the only thing that should theoretically subscribe to an inventory object is the User singleton.
          This has the effect of making User's inventory object something of a Singleton in itself. Never use Inventory
          if not getting it through User.
 **/

#import "Inventory.h"

@implementation Inventory

@synthesize numBarrels = _numBarrels, numDoors = _numDoors, sg = _sg, numShields = _numShields, numSignposts = _numSignposts, numSpiders = _numSpiders, numTraps = _numTraps;

- (id) initWithBarrels:(int)barrels doors:(int)doors sg:(int)sg shields:(int)shields signposts:(int)signposts spiders:(int)spiders traps:(int)traps
{
    self = [super init];
    if (self) {
        _numBarrels = barrels;
        _numDoors = doors;
        _sg = sg;
        _numShields = shields;
        _numSignposts = signposts;
        _numSpiders = spiders;
        _numTraps = traps;
    }
    return self;
}

/*
 MANUAL SETTERS
 Done to be able to notify subscribers
 */

- (void) setNumBarrels:(int)numBarrels
{
    _numBarrels = numBarrels;
    [self notifySubscribers:ModelUpdateEventInventory];
}

- (void) setNumDoors:(int)numDoors
{
    _numDoors = numDoors;
    [self notifySubscribers:ModelUpdateEventInventory];
}

- (void) setSg:(int)sg
{
    _sg = sg;
    [self notifySubscribers:ModelUpdateEventInventory];
}

- (void) setNumShields:(int)numShields
{
    _numShields = numShields;
    [self notifySubscribers:ModelUpdateEventInventory];
}

- (void) setNumSignposts:(int)numSignposts
{
    _numSignposts = numSignposts;
    [self notifySubscribers:ModelUpdateEventInventory];
}

- (void) setNumSpiders:(int)numSpiders
{
    _numSpiders = numSpiders;
    [self notifySubscribers:ModelUpdateEventInventory];
}

- (void) setNumTraps:(int)numTraps
{
    _numTraps = numTraps;
    [self notifySubscribers:ModelUpdateEventInventory];
}


@end
