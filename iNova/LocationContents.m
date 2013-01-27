//
//  LocationContents.m
//  iNova
//
//  Created by Kyle Hughes on 4/13/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

/*
    NOTE: In theory this should subclass something along with Inventory since they share many of the same methods / properties, but due to
          Inventory's unique nature as a Notifier and all of the custom setter methods, that would not actually make this any more robust.
          It's not that big of a deal at this point. Yes I'm only writing this to assure myself of these previously listed things.
 */

#import "LocationContents.h"

@implementation LocationContents

@synthesize trap = _trap, spider = _spider, barrel = _barrel, doorways = _doorways, signposts = _signposts;

- (id) initWithTrap:(Trap *)trap spider:(Spider *)spider barrel:(Barrel *)barrel doorways:(NSMutableArray *)doorways signposts:(NSMutableArray *)signposts
{
    self = [super init];
    if (self) 
    {
        _trap = trap;
        _spider = spider;
        _barrel = barrel;
        _doorways = doorways;
        _signposts = signposts;
    }
    return self;
}

@end
