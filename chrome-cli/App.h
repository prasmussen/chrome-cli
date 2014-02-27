//
//  App.h
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arguments.h"

@interface App : NSObject

- (void)listWindows:(Arguments *)args;
- (void)listTabs:(Arguments *)args;
- (void)listTabsLinks:(Arguments *)args;
- (void)listTabsInWindow:(Arguments *)args;
- (void)listTabsLinksInWindow:(Arguments *)args;
- (void)printActiveTabInfo:(Arguments *)args;
- (void)printTabInfo:(Arguments *)args;
- (void)openUrlInNewTab:(Arguments *)args;
- (void)openUrlInNewWindow:(Arguments *)args;
- (void)openUrlInNewIncognitoWindow:(Arguments *)args;
- (void)openUrlInTab:(Arguments *)args;
- (void)openUrlInWindow:(Arguments *)args;
- (void)reloadActiveTab:(Arguments *)args;
- (void)reloadTab:(Arguments *)args;
- (void)closeActiveTab:(Arguments *)args;
- (void)closeTab:(Arguments *)args;
- (void)closeActiveWindow:(Arguments *)args;
- (void)closeWindow:(Arguments *)args;
- (void)goBackActiveTab:(Arguments *)args;
- (void)goBackInTab:(Arguments *)args;
- (void)goForwardActiveTab:(Arguments *)args;
- (void)goForwardInTab:(Arguments *)args;
- (void)activateTab:(Arguments *)args;
- (void)enterPresentationModeWithActiveTab:(Arguments *)args;
- (void)enterPresentationModeWithTab:(Arguments *)args;
- (void)exitPresentationMode:(Arguments *)args;
- (void)printActiveWindowSize:(Arguments *)args;
- (void)printWindowSize:(Arguments *)args;
- (void)setActiveWindowSize:(Arguments *)args;
- (void)setWindowSize:(Arguments *)args;
- (void)printActiveWindowPosition:(Arguments *)args;
- (void)printWindowPosition:(Arguments *)args;
- (void)setActiveWindowPosition:(Arguments *)args;
- (void)setWindowPosition:(Arguments *)args;
- (void)executeJavascriptInActiveTab:(Arguments *)args;
- (void)executeJavascriptInTab:(Arguments *)args;
- (void)printSourceFromActiveTab:(Arguments *)args;
- (void)printSourceFromTab:(Arguments *)args;
- (void)printChromeVersion:(Arguments *)args;
- (void)printVersion:(Arguments *)args;

@end
