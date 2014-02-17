//
//  Argument.h
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Arguments : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)asString:(NSString *)name;
- (NSInteger)asInteger:(NSString *)name;
- (float)asFloat:(NSString *)name;

@end
