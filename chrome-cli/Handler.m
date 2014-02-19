//
//  Handler.m
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import "Handler.h"
#import "Arguments.h"

@implementation Handler {
    NSArray *_args;
    NSObject *_target;
    SEL _action;
    NSString *_description;
}

- (id)initWithArgs:(NSArray *)args target:(NSObject *)target action:(SEL)action description:(NSString *)description {
    self = [super init];

    self->_args = args;
    self->_target = target;
    self->_action = action;
    self->_description = description;

    return self;
}

- (NSString *)pattern {
    return [self->_args componentsJoinedByString:@" "];
}

- (NSString *)description {
    return self->_description;
}

- (BOOL)match:(NSArray *)args {
    if (args.count != self->_args.count) {
        return false;
    }

    for (int i = 0; i < args.count; i++) {
        NSString *argA = [self->_args objectAtIndex:i];
        NSString *argB = [args objectAtIndex:i];

        // Don't compare capture group arguments
        if ([self isCaptureGroup:argA]) {
            continue;
        }

        if (![argA isEqualToString:argB]) {
            return false;
        }
    }
    return true;
}

- (void)call:(NSArray *)args {
    NSMutableDictionary *captureGroups = [[NSMutableDictionary alloc] init];

    // Grab capture groups and store them as a key value pair in the dictionary
    for (int i = 0; i < args.count; i++) {
        NSString *argA = [self->_args objectAtIndex:i];
        NSString *argB = [args objectAtIndex:i];

        if ([self isCaptureGroup:argA]) {
            NSString *name = [self getCaptureGroup:argA];
            [captureGroups setObject:argB forKey:name];
        }
    }

    Arguments *arguments = [[Arguments alloc] initWithDictionary:captureGroups];
    [self->_target performSelector:self->_action withObject:arguments];
}

- (BOOL)isCaptureGroup:(NSString *)arg {
    return [arg hasPrefix:@"<"] && [arg hasSuffix:@">"];
}

- (NSString *)getCaptureGroup:(NSString *)arg {
    return [arg substringWithRange:NSMakeRange(1, arg.length - 2)];
}

@end
