//
//  Trap.m
//  iNova
//
//  Created by Kyle Hughes on 4/21/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "Trap.h"

@implementation Trap

@synthesize idNum = _idNum, username = _username;

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

@end
