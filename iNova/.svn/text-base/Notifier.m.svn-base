//
//  Notifier.m
//  iNova
//
//  Created by Kyle Hughes on 4/6/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

/**
    NOTE: This should be thought of as an abstract class and should _not_ be instantiated.
 
    USAGE:
        A model should extends Notifier if they want to allow for objects (generally UIViewControllers) to subscribed to
        any potential updates to their properties.
        Something that extends Notifier should implement custom setter methods for the properties that should send out notifications when changed.
        For an example implementation, see User.
 
    SECOND NOTE: Please realize that, as of 4/6/12, I have never tested
                 anything to do with Notifying; I don't know if using the
                 custom-setter method works with synthesizing. I'm only doing
                 this now so that the framework is in place to use (and
                 debug) once we get login working.
 **/

#import "Notifier.h"

@implementation Notifier

@synthesize subscribers = _subscribers;

- (id) init
{
    self = [super init];
    if(self)
    {
        _subscribers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) notifySubscribers:(ModelUpdateEvent)event
{
    for(id<Subscriber> subscriber in self.subscribers)
    {
        [subscriber notify:event];
    }
}

- (BOOL) subscribe:(id<Subscriber>)subscriber
{
    if (![self.subscribers containsObject:subscriber]) {
        [self.subscribers addObject:subscriber];
        return true;
    }
    return false;
}

- (BOOL) unsubscribe:(id<Subscriber>)subscriber
{
    if ([self.subscribers containsObject:subscriber]) {
        [self.subscribers removeObject:subscriber];
        return true;
    }
    return false;
}

@end
