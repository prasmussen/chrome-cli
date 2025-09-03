//
//  App.m
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import "App.h"
#import "chrome.h"
#import <ApplicationServices/ApplicationServices.h>


static NSInteger const kMaxLaunchTimeInSeconds = 15;
static NSString * const kVersion = @"1.11.0";
static NSString * const kJsPrintSource = @"(function() { return document.getElementsByTagName('html')[0].outerHTML })();";



@implementation App {
    NSString *bundleIdentifier;
    OutputFormat outputFormat;
}

- (id)initWithBundleIdentifier:(NSString *)bundleIdentifier outputFormat:(OutputFormat)outputFormat {
    self = [super init];
    self->bundleIdentifier = bundleIdentifier;
    self->outputFormat = outputFormat;
    return self;
}


- (chromeApplication *)chrome {
    chromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:self->bundleIdentifier];

    if ([chrome isRunning]) {
        return chrome;
    }

    if (self->outputFormat == kOutputFormatText) {
        printf("Waiting for chrome to start...\n");
    }
    [chrome activate];
    NSDate *start = [NSDate date];

    // Wait until chrome has one or more windows or give up if MaxLaunchTime is reached
    while ([[NSDate date] timeIntervalSinceDate:start] < kMaxLaunchTimeInSeconds) {
        // Sleep for 100ms
        usleep(100000);

        if ([chrome.windows count] > 0) {
            return chrome;
        }
    }

    if (self->outputFormat == kOutputFormatText) {
        printf("Chrome did not start for %ld seconds\n", kMaxLaunchTimeInSeconds);
    }
    exit(1);
}


- (void)listWindows:(Arguments *)args {
    if (self->outputFormat == kOutputFormatJSON) {
        NSMutableArray *windowInfos = [[NSMutableArray alloc] init];

        for (chromeWindow *window in self.chrome.windows) {
            NSDictionary *windowInfo = @{
                @"id" : window.id,
                @"name" : window.name,
            };
            [windowInfos addObject:windowInfo];
        }

        NSDictionary *output = @{
            @"windows" : windowInfos,
        };
        [self printJSON:output];
    } else {
        for (chromeWindow *window in self.chrome.windows) {
            printf("[%s] %s\n", window.id.UTF8String, window.name.UTF8String);
        }
    }

}

- (void)listTabs:(Arguments *)args {
    if (self->outputFormat == kOutputFormatJSON) {
        NSMutableArray *tabInfos = [[NSMutableArray alloc] init];

        for (chromeWindow *window in self.chrome.windows) {
            for (chromeTab *tab in window.tabs) {
                NSDictionary *tabInfo = @{
                    @"windowId" : window.id,
                    @"windowName" : window.name,
                    @"id" : tab.id,
                    @"title" : tab.title,
                    @"url" : tab.URL,
                };
                [tabInfos addObject:tabInfo];
            }
        }

        NSDictionary *output = @{
            @"tabs" : tabInfos,
        };
        [self printJSON:output];
    } else {
        for (chromeWindow *window in self.chrome.windows) {
            for (chromeTab *tab in window.tabs) {
                if (self.chrome.windows.count > 1) {
                    printf("[%s:%s] %s\n", window.id.UTF8String, tab.id.UTF8String, tab.title.UTF8String);
                } else {
                    printf("[%s] %s\n", tab.id.UTF8String, tab.title.UTF8String);
                }
            }
        }
    }
}

- (void)listTabsLinks:(Arguments *)args {
    if (self->outputFormat == kOutputFormatJSON) {
        NSMutableArray *tabInfos = [[NSMutableArray alloc] init];

        for (chromeWindow *window in self.chrome.windows) {
            for (chromeTab *tab in window.tabs) {
                NSDictionary *tabInfo = @{
                    @"windowId" : window.id,
                    @"windowName" : window.name,
                    @"id" : tab.id,
                    @"title" : tab.title,
                    @"url" : tab.URL,
                };
                [tabInfos addObject:tabInfo];
            }
        }

        NSDictionary *output = @{
            @"tabs" : tabInfos,
        };
        [self printJSON:output];
    } else {
        for (chromeWindow *window in self.chrome.windows) {
            for (chromeTab *tab in window.tabs) {
                if (self.chrome.windows.count > 1) {
                    printf("[%s:%s] %s\n", window.id.UTF8String, tab.id.UTF8String, tab.URL.UTF8String);
                } else {
                    printf("[%s] %s\n", tab.id.UTF8String, tab.URL.UTF8String);
                }
            }
        }
    }
}

- (void)listTabsWithLink:(Arguments *)args {
    if (self->outputFormat == kOutputFormatJSON) {
        NSMutableArray *tabInfos = [[NSMutableArray alloc] init];
        for(chromeWindow *window in self.chrome.windows) {
            for (chromeTab *tab in window.tabs) {
                NSDictionary *tabInfo = @{
                    @"windowId": window.id,
                    @"windowName": window.name,
                    @"id": tab.id,
                    @"title": tab.title,
                    @"url": tab.URL,
                };
                [tabInfos addObject:tabInfo];
            }
        }
        NSDictionary *output = @{
            @"tabs": tabInfos,
        };
        [self printJSON:output];
    } else {
        for (chromeWindow *window in self.chrome.windows) {
            for (chromeTab *tab in window.tabs) {
                if (self.chrome.windows.count > 1) {
                    printf("[%s:%s] title: %s, url: %s\n", window.id.UTF8String, tab.id.UTF8String, tab.title.UTF8String, tab.URL.UTF8String);
                } else {
                    printf("[%s] title: %s, url: %s\n", tab.id.UTF8String, tab.title.UTF8String, tab.URL.UTF8String);
                }
            }
        }
    }
}

- (void)listTabsInWindow:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    chromeWindow *window = [self findWindow:windowId];

    if (!window) {
        return;
    }


    if (self->outputFormat == kOutputFormatJSON) {
        NSMutableArray *tabInfos = [[NSMutableArray alloc] init];

        for (chromeTab *tab in window.tabs) {
            NSDictionary *tabInfo = @{
                @"windowId" : window.id,
                @"windowName" : window.name,
                @"id" : tab.id,
                @"title" : tab.title,
                @"url" : tab.URL,
            };
            [tabInfos addObject:tabInfo];
        }

        NSDictionary *output = @{
            @"tabs" : tabInfos,
        };
        [self printJSON:output];
    } else {
        for (chromeTab *tab in window.tabs) {
            printf("[%s] %s\n", tab.id.UTF8String, tab.title.UTF8String);
        }
    }
}

- (void)listTabsLinksInWindow:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    chromeWindow *window = [self findWindow:windowId];

    if (!window) {
        return;
    }

    if (self->outputFormat == kOutputFormatJSON) {
        NSMutableArray *tabInfos = [[NSMutableArray alloc] init];

        for (chromeTab *tab in window.tabs) {
            NSDictionary *tabInfo = @{
                @"windowId" : window.id,
                @"windowName" : window.name,
                @"id" : tab.id,
                @"title" : tab.title,
                @"url" : tab.URL,
            };
            [tabInfos addObject:tabInfo];
        }

        NSDictionary *output = @{
            @"tabs" : tabInfos,
        };
        [self printJSON:output];
    } else {
        for (chromeTab *tab in window.tabs) {
            printf("[%s] %s\n", tab.id.UTF8String, tab.URL.UTF8String);
        }
    }
}

- (void)printActiveTabInfo:(Arguments *)args {
    chromeTab *tab = [self activeTab];
    [self printInfo:tab];
}

- (void)printTabInfo:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    chromeTab *tab = [self findTab:tabId];
    [self printInfo:tab];
}

- (void)openUrlInNewTab:(Arguments *)args {
    NSString *url = [args asString:@"url"];

    chromeTab *tab = [[[self.chrome classForScriptingClass:@"tab"] alloc] init];
    chromeWindow *window = [self activeWindow];
    [window.tabs addObject:tab];
    tab.URL = url;

    [self printInfo:tab];
}

- (void)openUrlInNewWindow:(Arguments *)args {
    NSString *url = [args asString:@"url"];

    chromeWindow *window = [[[self.chrome classForScriptingClass:@"window"] alloc] init];
    [self.chrome.windows addObject:window];

    chromeTab *tab = [window.tabs firstObject];
    tab.URL = url;

    [self printInfo:tab];
}

- (void)openUrlInNewIncognitoWindow:(Arguments *)args {
    NSString *url = [args asString:@"url"];

    chromeWindow *window = [[[self.chrome classForScriptingClass:@"window"] alloc] initWithProperties:@{@"mode": @"incognito"}];
    [self.chrome.windows addObject:window];

    chromeTab *tab = [window.tabs firstObject];
    tab.URL = url;

    [self printInfo:tab];
}

- (void)openUrlInTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    NSString *url = [args asString:@"url"];

    chromeTab *tab = [self findTab:tabId];

    if (tab) {
        tab.URL = url;
    }
}

- (void)openUrlInWindow:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    NSString *url = [args asString:@"url"];

    chromeTab *tab = [[[self.chrome classForScriptingClass:@"tab"] alloc] init];
    chromeWindow *window = [self findWindow:windowId];

    if (!window) {
        return;
    }

    [window.tabs addObject:tab];
    tab.URL = url;

    [self printInfo:tab];
}

- (void)reloadActiveTab:(Arguments *)args {
    chromeTab *tab = [self activeTab];

    if (tab) {
        [tab reload];
    }
}

- (void)reloadTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    chromeTab *tab = [self findTab:tabId];

    if (tab) {
        [tab reload];
    }
}

- (void)closeActiveTab:(Arguments *)args {
    chromeTab *tab = [self activeTab];

    if (tab) {
        [tab close];
    }
}

- (void)closeTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    chromeTab *tab = [self findTab:tabId];

    if (tab) {
        [tab close];
    }
}

- (void)closeActiveWindow:(Arguments *)args {
    chromeWindow *window = [self activeWindow];

    if (window) {
        [window close];
    }
}

- (void)closeWindow:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    chromeWindow *window = [self findWindow:windowId];

    if (window) {
        [window close];
    }
}


- (void)goBackActiveTab:(Arguments *)args {
    chromeTab *tab = [self activeTab];

    if (tab) {
        [tab goBack];
    }
}

- (void)goBackInTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    chromeTab *tab = [self findTab:tabId];

    if (tab) {
        [tab goBack];
    }
}

- (void)goForwardActiveTab:(Arguments *)args {
    chromeTab *tab = [self activeTab];

    if (tab) {
        [tab goForward];
    }
}

- (void)goForwardInTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    chromeTab *tab = [self findTab:tabId];

    if (tab) {
        [tab goForward];
    }
}

- (void)activateTab:(Arguments *)args {
    // Support legacy and explicit forms:
    // 1) <tabId>
    // 2) <windowId>:<tabId> (prefer window match, fallback to scanning)
    NSString *rawId = [args asString:@"id"];
    if (!rawId || rawId.length == 0) {
        return;
    }

    NSRange sep = [rawId rangeOfString:@":"]; 
    if (sep.location != NSNotFound) {
        NSString *winStr = [rawId substringToIndex:sep.location];
        NSString *tabStr = [rawId substringFromIndex:sep.location + 1];

        NSInteger windowId = [winStr integerValue];
        NSInteger tabId = [tabStr integerValue];
        BOOL done = NO;
        chromeWindow *window = [self findWindow:windowId];
        if (!window) {
        } else {
            chromeTab *tabInWindow = [self findTab:tabId inWindow:window];
            if (tabInWindow) {
                [self setTabActive:tabInWindow inWindow:window];
                done = YES;
            } else {
            }
        }

        if (!done) {
            chromeTab *tabAny = [self findTab:tabId];
            chromeWindow *winAny = tabAny ? [self findWindowWithTab:tabAny] : nil;
            if (tabAny && winAny) {
                [self setTabActive:tabAny inWindow:winAny];
            } else {
            }
        }
        return;
    }

    // Fallback to legacy behavior: search all windows for tabId
    NSInteger tabId = [rawId integerValue];
    chromeTab *tab = [self findTab:tabId];
    chromeWindow *window = [self findWindowWithTab:tab];
    [self setTabActive:tab inWindow:window];
}

// Same parsing as activateTab:, but ensures the window is brought to the foreground
- (void)activateTabAndFocus:(Arguments *)args {
    [self activateTab:args];

    NSString *rawId = [args asString:@"id"];
    if (!rawId || rawId.length == 0) {
        return;
    }

    // Determine tabId and attempt to focus the window containing it with retries
    NSInteger tabId = 0;
    NSRange sep = [rawId rangeOfString:@":"]; 
    if (sep.location != NSNotFound) {
        NSString *tabStr = [rawId substringFromIndex:sep.location + 1];
        tabId = [tabStr integerValue];
    } else {
        tabId = [rawId integerValue];
    }

    BOOL focused = [self focusWindowContainingTabId:tabId maxAttempts:12 sleepMs:150];
    if (!focused) {
    }
}

- (void)printActiveWindowSize:(Arguments *)args {
    chromeWindow *window = [self activeWindow];
    CGSize size = window.bounds.size;

    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"width" : @(size.width),
            @"height" : @(size.height),
        };
        [self printJSON:output];
    } else {
        printf("width: %f, height: %f\n", size.width, size.height);
    }

}

- (void)printWindowSize:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    chromeWindow *window = [self findWindow:windowId];
    CGSize size = window.bounds.size;
    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"width" : @(size.width),
            @"height" : @(size.height),
        };
        [self printJSON:output];
    } else {
        printf("width: %f, height: %f\n", size.width, size.height);
    }
}

- (void)setActiveWindowSize:(Arguments *)args {
    float width = [args asFloat:@"width"];
    float height = [args asFloat:@"height"];

    chromeWindow *window = [self activeWindow];
    CGPoint origin = window.bounds.origin;
    window.bounds = NSMakeRect(origin.x, origin.y, width, height);
}

- (void)setWindowSize:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    float width = [args asFloat:@"width"];
    float height = [args asFloat:@"height"];

    chromeWindow *window = [self findWindow:windowId];
    CGPoint origin = window.bounds.origin;
    window.bounds = NSMakeRect(origin.x, origin.y, width, height);
}

- (void)printActiveWindowPosition:(Arguments *)args {
    chromeWindow *window = [self activeWindow];
    CGPoint origin = window.bounds.origin;

    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"x" : @(origin.x),
            @"y" : @(origin.y),
        };
        [self printJSON:output];
    } else {
        printf("x: %f, y: %f\n", origin.x, origin.y);
    }
}

- (void)printWindowPosition:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    chromeWindow *window = [self findWindow:windowId];
    CGPoint origin = window.bounds.origin;

    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"x" : @(origin.x),
            @"y" : @(origin.y),
        };
        [self printJSON:output];
    } else {
        printf("x: %f, y: %f\n", origin.x, origin.y);
    }
}

- (void)setActiveWindowPosition:(Arguments *)args {
    float x = [args asFloat:@"x"];
    float y = [args asFloat:@"y"];

    chromeWindow *window = [self activeWindow];
    CGSize size = window.bounds.size;
    window.bounds = NSMakeRect(x, y, size.width, size.height);
}

- (void)setWindowPosition:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    float x = [args asFloat:@"x"];
    float y = [args asFloat:@"y"];

    chromeWindow *window = [self findWindow:windowId];
    CGSize size = window.bounds.size;
    window.bounds = NSMakeRect(x, y, size.width, size.height);
}

- (void)executeJavascriptInActiveTab:(Arguments *)args {
    NSString *js = [args asString:@"javascript"];

    chromeTab *tab = [self activeTab];
    if (!tab) {
        return;
    }

    id data = [tab executeJavascript:js];

    if (self->outputFormat == kOutputFormatJSON) {
        NSString *jsOutput = [[NSString alloc] init];
        if (data) {
            jsOutput = (NSString *)data;
        }
        NSDictionary *output = @{
            @"output" : jsOutput,
        };
        [self printJSON:output];
    } else {
        if (!data) {
            return;
        }
        printf("%s\n", [(NSString *)data UTF8String]);
    }
}

- (void)executeJavascriptInTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    NSString *js = [args asString:@"javascript"];

    chromeTab *tab = [self findTab:tabId];
    if (!tab) {
        return;
    }

    id data = [tab executeJavascript:js];

    if (self->outputFormat == kOutputFormatJSON) {
        NSString *jsOutput = [[NSString alloc] init];
        if (data) {
            jsOutput = (NSString *)data;
        }
        NSDictionary *output = @{
            @"output" : jsOutput,
        };
        [self printJSON:output];
    } else {
        if (!data) {
            return;
        }
        printf("%s\n", [(NSString *)data UTF8String]);
    }
}

- (void)printSourceFromActiveTab:(Arguments *)args {
    chromeTab *tab = [self activeTab];
    if (!tab) {
        return;
    }

    id data = [tab executeJavascript:kJsPrintSource];

    if (self->outputFormat == kOutputFormatJSON) {
        NSString *jsOutput = [[NSString alloc] init];
        if (data) {
            jsOutput = (NSString *)data;
        }
        NSDictionary *output = @{
            @"source" : jsOutput,
        };
        [self printJSON:output];
    } else {
        if (!data) {
            return;
        }
        printf("%s\n", [(NSString *)data UTF8String]);
    }
}

- (void)printSourceFromTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];

    chromeTab *tab = [self findTab:tabId];
    if (!tab) {
        return;
    }

    id data = [tab executeJavascript:kJsPrintSource];

    if (self->outputFormat == kOutputFormatJSON) {
        NSString *jsOutput = [[NSString alloc] init];
        if (data) {
            jsOutput = (NSString *)data;
        }
        NSDictionary *output = @{
            @"source" : jsOutput,
        };
        [self printJSON:output];
    } else {
        if (!data) {
            return;
        }
        printf("%s\n", [(NSString *)data UTF8String]);
    }
}

- (void)printChromeVersion:(Arguments *)args {
    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"version" : self.chrome.version,
        };
        [self printJSON:output];
    } else {
        printf("%s\n", self.chrome.version.UTF8String);
    }
}


- (void)printVersion:(Arguments *)args {

    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"version" : kVersion,
        };
        [self printJSON:output];
    } else {
        printf("%s\n", kVersion.UTF8String);
    }
}


#pragma mark Helper functions

// Best-effort focusing: Scripting Bridge bring-to-front plus Accessibility raise to switch Spaces/fullscreen
- (void)bringWindowToFrontBestEffort:(chromeWindow *)window targetTabTitle:(NSString *)tabTitleOrNil {
    if (!window) { return; }

    // First try via Scripting Bridge
    @try {
        window.minimized = NO;
        window.visible = YES;
        window.index = 1;
    } @catch (NSException *exception) {
        // Ignore SB quirks
    }
    [self.chrome activate];

    // Then try Accessibility-based raise to ensure macOS switches to the Space containing this window
    // Request trust (this will show the system prompt once if not granted)
    NSDictionary *promptOpts = @{(__bridge NSString *)kAXTrustedCheckOptionPrompt: @NO};
    Boolean trusted = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)promptOpts);
    if (!trusted) {
        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{(__bridge NSString *)kAXTrustedCheckOptionPrompt: @YES});
        return;
    }

    // Find the running app for our bundle id
    pid_t pid = 0;
    NSArray<NSRunningApplication *> *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:self->bundleIdentifier];
    if (apps.count == 0) { return; }
    // Prefer the frontmost or first
    for (NSRunningApplication *app in apps) {
        if (app.active) { pid = app.processIdentifier; break; }
    }
    if (pid == 0) { pid = apps.firstObject.processIdentifier; }

    AXUIElementRef appRef = AXUIElementCreateApplication(pid);
    if (!appRef) { return; }

    CFTypeRef windowsValue = NULL;
    if (AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, &windowsValue) != kAXErrorSuccess || !windowsValue) {
        CFRelease(appRef);
        return;
    }

    NSArray *axWindows = CFBridgingRelease(windowsValue);
    NSString *targetTitle = tabTitleOrNil ?: (window.name ?: @"");
    for (id w in axWindows) {
        AXUIElementRef winRef = (__bridge AXUIElementRef)w;
        CFTypeRef titleValue = NULL;
        if (AXUIElementCopyAttributeValue(winRef, kAXTitleAttribute, &titleValue) == kAXErrorSuccess && titleValue) {
            NSString *title = CFBridgingRelease(titleValue);
            BOOL matches = NO;
            if (title && targetTitle.length > 0) {
                if ([title isEqualToString:targetTitle]) {
                    matches = YES;
                } else {
                    NSRange r = [title rangeOfString:targetTitle options:NSCaseInsensitiveSearch];
                    matches = (r.location != NSNotFound);
                }
            }
            if (matches) {
                AXUIElementPerformAction(winRef, kAXRaiseAction);
                break;
            }
        }
    }

    CFRelease(appRef);
}

- (chromeWindow *)activeWindow {
    // The first object seems to alway be the active window
    chromeWindow *window = self.chrome.windows.firstObject;

    // Create new window if no window exist
    if (!window) {
        window = [[[self.chrome classForScriptingClass:@"window"] alloc] init];
        [self.chrome.windows addObject:window];
    }

    return window;
}

- (chromeWindow *)findWindow:(NSInteger)windowId {
    chromeWindow *window = [self.chrome.windows objectWithID:@(windowId)];

    if (window && window.id) {
        return window;
    }

    return nil;
}

- (chromeTab *)activeTab {
    return [self activeWindow].activeTab;
}

- (void)setTabActive:(chromeTab *)tab inWindow:(chromeWindow *)window {
    NSInteger index = [self findTabIndex:tab inWindow:window];
    window.activeTabIndex = index;
}

- (chromeTab *)findTab:(NSInteger)tabId {
    for (chromeWindow *window in self.chrome.windows) {
        chromeTab *tab = [window.tabs objectWithID:@(tabId)];
        if (tab && tab.id) {
            return tab;
        }
    }

    return nil;
}

- (chromeWindow *)findWindowWithTab:(chromeTab *)tab {
    for (chromeWindow *window in self.chrome.windows) {
        for (chromeTab *t in window.tabs) {
            if ([t.id isEqualToString:tab.id]) {
                return window;
            }
        }
    }

    return nil;
}

- (chromeTab *)findTab:(NSInteger)tabId inWindow:(chromeWindow *)window {
    if (!window) {
        return nil;
    }
    chromeTab *tab = [window.tabs objectWithID:@(tabId)];
    if (tab && tab.id) {
        return tab;
    }
    return nil;
}

- (NSInteger)findTabIndex:(chromeTab *)tab inWindow:(chromeWindow *)window {
    // Tab index starts at 1
    int i = 1;

    for (chromeTab *t in window.tabs) {
        if ([t.id isEqualToString:tab.id]) {
            return i;
        }
        i++;
    }

    return NSNotFound;
}

// Try to bring to front the window containing tabId, with retries (helps when Chrome is fullscreen across Spaces)
- (BOOL)focusWindowContainingTabId:(NSInteger)tabId maxAttempts:(int)attempts sleepMs:(int)ms {
    for (int attempt = 1; attempt <= attempts; attempt++) {
        NSArray *windowsSnapshot = [NSArray arrayWithArray:self.chrome.windows];
        for (chromeWindow *w in windowsSnapshot) {
            NSArray *tabsSnapshot = [NSArray arrayWithArray:w.tabs];
            for (chromeTab *t in tabsSnapshot) {
                if (t.id && [t.id integerValue] == tabId) {
                    // Ensure the tab is the active one in that window
                    [self setTabActive:t inWindow:w];
                    // Bring to front using both SB and AX with the active tab title (more reliable match)
                    [self bringWindowToFrontBestEffort:w targetTabTitle:(t.title ?: nil)];

                    // Give macOS a moment and verify
                    usleep((useconds_t)(ms * 1000));
                    chromeWindow *aw = [self activeWindow];
                    if (aw && [aw.id isEqualToString:w.id]) {
                        return YES;
                    } else {
                    }
                }
            }
        }
        usleep((useconds_t)(ms * 1000));
    }
    return NO;
}

- (void)printInfo:(chromeTab *)tab {
    if (!tab) {
        return;
    }

    if (self->outputFormat == kOutputFormatJSON) {
        NSDictionary *output = @{
            @"id" : tab.id,
            @"windowId" : [self activeWindow].id,
            @"title" : tab.title,
            @"url" : tab.URL,
            @"loading" : @(tab.loading),
        };
        [self printJSON:output];
    } else {
        printf("Id: %s\n", tab.id.UTF8String);
        printf("Window id: %s\n", [self activeWindow].id.UTF8String);
        printf("Title: %s\n", tab.title.UTF8String);
        printf("Url: %s\n", tab.URL.UTF8String);
        printf("Loading: %s\n", tab.loading ? "Yes" : "No");
    }
}

- (void)printJSON:(NSDictionary *)output {
    NSJSONWritingOptions options = [self jsonWritingOptions];
    NSData *data = [NSJSONSerialization dataWithJSONObject:output options:options error: nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    printf("%s\n", [string UTF8String]);
}

- (NSJSONWritingOptions)jsonWritingOptions {
    if (@available(macOS 10.15, *)) {
        return NSJSONWritingPrettyPrinted | NSJSONWritingWithoutEscapingSlashes | NSJSONWritingSortedKeys;
    } else if (@available(macOS 10.13, *)) {
        return NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys;
    }
    return NSJSONWritingPrettyPrinted;
}

@end
