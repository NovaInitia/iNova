//
//  Notifier.h
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelUpdateEvent.h"
#import "Subscriber.h"

@interface Notifier : NSObject

@property (nonatomic, retain) NSMutableArray* subscribers;

- (id) init;

- (BOOL) subscribe:(id<Subscriber>)subscriber;
- (BOOL) unsubscribe:(id<Subscriber>)subscriber;

- (void) notifySubscribers:(ModelUpdateEvent)event;

@end
