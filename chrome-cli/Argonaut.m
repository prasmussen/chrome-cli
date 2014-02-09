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
    NSMutableArray *handlers;
    NSString *appName;
}


- (id) init {
    self = [super init];
    self->handlers = [[NSMutableArray alloc] init];
    return self;
}

- (void)add:(NSString *)pattern target:(NSObject *)target action:(SEL)action description:(NSString *)description {
    NSArray *args = [pattern componentsSeparatedByString:@" "];
    Handler *handler = [[Handler alloc] initWithArgs:args target:target action:action description:description];
    [self->handlers addObject:handler];
}

- (BOOL)parse {
    NSMutableArray *args = [NSMutableArray arrayWithArray:[[NSProcessInfo processInfo] arguments]];

    // Grab binary name
    self->appName = [[args.firstObject pathComponents] lastObject];

    // Remove application path argument
    [args removeObjectAtIndex:0];

    for (Handler *handler in self->handlers) {
        if ([handler match:args]) {
            [handler call:args];
            return true;
        }
    }
    return false;
}

- (void)printUsage:(Arguments *)args {
    [self printUsage];
}

- (void)printUsage {
    printf("Usage:\n");

    for (Handler *handler in self->handlers) {
        printf("%s %s  (%s)\n", self->appName.UTF8String, handler.pattern.UTF8String, handler.description.UTF8String);
    }
}

@end
