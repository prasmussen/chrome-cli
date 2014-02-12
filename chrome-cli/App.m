//
//  App.m
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import "App.h"
#import "chrome.h"


static NSString * const kJsPrintSource = @"(function() { return document.getElementsByTagName('html')[0].outerHTML })();";


@implementation App {
    chromeApplication *chrome;
}

- (id)init {
    self = [super init];
    self->chrome = [SBApplication applicationWithBundleIdentifier:@"com.google.Chrome"];
    return self;
}

- (void)listWindows:(Arguments *)args {
    for (chromeWindow *window in self->chrome.windows) {
        printf("[%ld] %s\n", (long)window.id, window.name.UTF8String);
    }
}

- (void)listTabs:(Arguments *)args {
    for (chromeWindow *window in self->chrome.windows) {
        for (chromeTab *tab in window.tabs) {
            if (self->chrome.windows.count > 1) {
                printf("[%ld:%ld] %s\n", (long)window.id, (long)tab.id, tab.title.UTF8String);
            } else {
                printf("[%ld] %s\n", (long)tab.id, tab.title.UTF8String);
            }
        }
    }
}

- (void)listTabsLinks:(Arguments *)args {
    for (chromeWindow *window in self->chrome.windows) {
        for (chromeTab *tab in window.tabs) {
            if (self->chrome.windows.count > 1) {
                printf("[%ld:%ld] %s\n", (long)window.id, (long)tab.id, tab.URL.UTF8String);
            } else {
                printf("[%ld] %s\n", (long)tab.id, tab.URL.UTF8String);
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

    for (chromeTab *tab in window.tabs) {
        printf("[%ld] %s\n", (long)tab.id, tab.title.UTF8String);
    }
}

- (void)listTabsLinksInWindow:(Arguments *)args {
    NSInteger windowId = [args asInteger:@"id"];
    chromeWindow *window = [self findWindow:windowId];
    
    if (!window) {
        return;
    }
    
    for (chromeTab *tab in window.tabs) {
        printf("[%ld] %s\n", (long)tab.id, tab.URL.UTF8String);
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

    chromeTab *tab = [[[self->chrome classForScriptingClass:@"tab"] alloc] init];
    chromeWindow *window = [self activeWindow];
    [window.tabs addObject:tab];
    tab.URL = url;

    [self printInfo:tab];
}

- (void)openUrlInNewWindow:(Arguments *)args {
    NSString *url = [args asString:@"url"];

    chromeWindow *window = [[[self->chrome classForScriptingClass:@"window"] alloc] init];
    [self->chrome.windows addObject:window];

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

    chromeTab *tab = [[[self->chrome classForScriptingClass:@"tab"] alloc] init];
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

- (void)executeJavascriptInActiveTab:(Arguments *)args {
    NSString *js = [args asString:@"javascript"];

    chromeTab *tab = [self activeTab];
    if (tab) {
        id data = [tab executeJavascript:js];
        if (data) {
            printf("%s\n", [(NSString *)data UTF8String]);
        }
    }
}

- (void)executeJavascriptInTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];
    NSString *js = [args asString:@"javascript"];

    chromeTab *tab = [self findTab:tabId];
    if (tab) {
        id data = [tab executeJavascript:js];
        if (data) {
            printf("%s\n", [(NSString *)data UTF8String]);
        }
    }
}

- (void)printSourceFromActiveTab:(Arguments *)args {
    chromeTab *tab = [self activeTab];
    if (tab) {
        id data = [tab executeJavascript:kJsPrintSource];
        if (data) {
            printf("%s\n", [(NSString *)data UTF8String]);
        }
    }
}

- (void)printSourceFromTab:(Arguments *)args {
    NSInteger tabId = [args asInteger:@"id"];

    chromeTab *tab = [self findTab:tabId];
    if (tab) {
        id data = [tab executeJavascript:kJsPrintSource];
        if (data) {
            printf("%s\n", [(NSString *)data UTF8String]);
        }
    }
}

- (void)printChromeVersion:(Arguments *)args {
    printf("%s\n", self->chrome.version.UTF8String);
}



#pragma mark Helper functions

- (chromeWindow *)activeWindow {
    // The first object seems to alway be the active window
    return self->chrome.windows.firstObject;
}

- (chromeWindow *)findWindow:(NSInteger)windowId {
    chromeWindow *window = [self->chrome.windows objectWithID:@(windowId)];

    if (window && window.id) {
        return window;
    }

    return nil;
}

- (chromeTab *)activeTab {
    return [self activeWindow].activeTab;
}

- (chromeTab *)findTab:(NSInteger)tabId {
    for (chromeWindow *window in self->chrome.windows) {
        chromeTab *tab = [window.tabs objectWithID:@(tabId)];
        if (tab && tab.id) {
            return tab;
        }
    }

    return nil;
}

- (void)printInfo:(chromeTab *)tab {
    if (tab) {
        printf("Id: %ld\n", (long)tab.id);
        printf("Title: %s\n", tab.title.UTF8String);
        printf("Url: %s\n", tab.URL.UTF8String);
        printf("Loading: %s\n", tab.loading ? "Yes" : "No");
    }
}

@end
