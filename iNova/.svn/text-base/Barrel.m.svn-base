//
//  Barrel.m
//  iNova
//
//  Created by Kyle Hughes on 4/21/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "Barrel.h"

@implementation Barrel

@synthesize idNum = _idNum, username = _username, sg = _sg, traps = _traps, barrels = _barrels, spiders = _spiders, shields = _shields, doorways = _doorways, signposts = _signposts, message = _message, label = _label;

- (id) initWithID:(int)idNum username:(NSString *)username
{
    self = [super init];
    if (self)
    {
        _idNum = idNum;
        _username = username;
    }
    return self;
}

- (void) addContentsSg:(NSUInteger)sg traps:(NSUInteger)traps barrels:(NSUInteger)barrels spiders:(NSUInteger)spiders shields:(NSUInteger)shields doorways:(NSUInteger)doorways signposts:(NSUInteger)signposts message:(NSString *)message label:(NSString *)label
{
    _sg = sg;
    _traps = traps;
    _barrels = barrels;
    _spiders = spiders;
    _shields = shields;
    _doorways = doorways;
    _signposts = signposts;
}

@end
