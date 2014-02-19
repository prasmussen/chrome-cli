//
//  Argonaut.m
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import "Argonaut.h"
#import "Handler.h"

@implementation Argonaut {
    NSMutableArray *_handlers;
}


- (id) init {
    self = [super init];
    self->_handlers = [[NSMutableArray alloc] init];
    return self;
}

- (void)add:(NSString *)pattern target:(NSObject *)target action:(SEL)action description:(NSString *)description {
    NSArray *args = [pattern componentsSeparatedByString:@" "];
    Handler *handler = [[Handler alloc] initWithArgs:args target:target action:action description:description];
    [self->_handlers addObject:handler];
}

- (BOOL)parse {
    Handler *handler = [self findHandler:[self args]];
    return handler != nil;
}

- (void)run {
    NSArray *args = [self args];
    Handler *handler = [self findHandler:args];
    [handler call:args];
}

- (NSString *)appName {
    NSString *path = [[NSProcessInfo processInfo] arguments].firstObject;
    return [path pathComponents].lastObject;
}

- (NSArray *)args {
    NSMutableArray *args = [NSMutableArray arrayWithArray:[[NSProcessInfo processInfo] arguments]];

    // Remove application path argument
    [args removeObjectAtIndex:0];

    return args;
}

- (Handler *)findHandler:(NSArray *)args {
    for (Handler *handler in self->_handlers) {
        if ([handler match:args]) {
            return handler;
        }
    }
    return nil;
}

- (void)printUsage:(Arguments *)args {
    [self printUsage];
}

- (void)printUsage {
    printf("Usage:\n");

    for (Handler *handler in self->_handlers) {
        printf("%s %s  (%s)\n", [self appName].UTF8String, handler.pattern.UTF8String, handler.description.UTF8String);
    }
}

@end
