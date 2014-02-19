//
//  Argument.m
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import "Arguments.h"

@implementation Arguments {
    NSDictionary *_dict;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    self->_dict = dict;
    return self;
}

- (NSString *)asString:(NSString *)name {
    return (NSString *)[self->_dict objectForKey:name];
}

- (NSInteger)asInteger:(NSString *)name {
    return [[self asString:name] integerValue];
}

- (float)asFloat:(NSString *)name {
    return [[self asString:name] floatValue];
}

@end
