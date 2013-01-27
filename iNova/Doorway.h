//
//  Doorway.h
//  iNova
//
//  Created by Kyle Hughes on 4/21/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "Tool.h"

@interface Doorway : Tool

@property (nonatomic) NSUInteger idNum;

@property (nonatomic, retain) NSString* user;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* hint;
@property (nonatomic, retain) NSString* comment;

@property (nonatomic) BOOL nsfw;

- (id) initWithID:(NSUInteger)idNum user:(NSString*)user url:(NSString*)url hint:(NSString*)hint comment:(NSString*)comment nsfw:(BOOL)nsfw;

@end
