//
//  Argonaut.h
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arguments.h"

@interface Argonaut : NSObject

- (void)add:(NSString *)pattern target:(NSObject *)target action:(SEL)action description:(NSString *)description;
- (BOOL)parse;
- (void)run;
- (void)printUsage;
- (void)printUsage:(Arguments *)args;

@end
