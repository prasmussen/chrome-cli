//
//  Handler.h
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Handler : NSObject

- (id)initWithArgs:(NSArray *)args target:(NSObject *)target action:(SEL)action description:(NSString *)description;
- (NSString *)pattern;
- (NSString *)description;
- (BOOL)match:(NSArray *)args;
- (void)call:(NSArray *)args;

@end
