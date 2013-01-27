//
//  Trap.h
//  iNova
//
//  Created by Kyle Hughes on 4/21/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "Tool.h"

@interface Trap : Tool

@property (nonatomic) int idNum;
@property (nonatomic, retain) NSString* username;

- (id) initWithID:(int)idNum username:(NSString*)username;

@end
