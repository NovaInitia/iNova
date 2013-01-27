//
//  User.h
//  iNova
//
//  Created by Kyle Hughes on 4/4/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlayerClass.h"
#import "Inventory.h"
#import "Notifier.h"

@interface User : Notifier <Subscriber>

@property (nonatomic) int idNum;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, setter = setClass:) PlayerClass class;
@property (nonatomic, retain) Inventory* inventory;
@property (nonatomic, setter = setExp:) int exp;
@property (nonatomic, setter = setLevel:) int level;
@property (nonatomic, setter = setShield:) BOOL shield;

+ (User*) sharedInstance;

- (void) syncInformationWithServer;

- (void) loadFromJSONString:(NSString*)json;

- (void) logout;

- (void) setClass:(PlayerClass)class;
- (void) setExp:(int)exp;
- (void) setLevel:(int)level;
- (void) setShield:(BOOL)shield;

@end
