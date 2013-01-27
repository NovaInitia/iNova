//
//  Inventory.h
//  iNova
//
//  Created by Kyle Hughes on 4/4/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notifier.h"

@interface Inventory : Notifier

// NOTE: may be possible to have all of these have the same setter method, if the setter sends an (id) with it. Not sure for now.
@property (nonatomic, setter = setNumBarrels:) int numBarrels;
@property (nonatomic, setter = setNumDoors:) int numDoors;
@property (nonatomic, setter = setSg:) int sg;
@property (nonatomic, setter = setNumShields:) int numShields;
@property (nonatomic, setter = setNumSignposts:) int numSignposts;
@property (nonatomic, setter = setNumSpiders:) int numSpiders;
@property (nonatomic, setter = setNumTraps:) int numTraps;

- (id) initWithBarrels:(int)barrels doors:(int)doors sg:(int)sg shields:(int)shields signposts:(int)signposts spiders:(int)spiders traps:(int)traps;

- (void) setNumBarrels:(int)numBarrels;
- (void) setNumDoors:(int)numDoors;
- (void) setSg:(int)sg;
- (void) setNumShields:(int)numShields;
- (void) setNumSignposts:(int)numSignposts;
- (void) setNumSpiders:(int)numSpiders;
- (void) setNumTraps:(int)numTraps;

@end