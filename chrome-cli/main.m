//
//  main.m
//  chrome-cli
//
//  Created by Petter Rasmussen on 08/02/14.
//  Copyright (c) 2014 Petter Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "Argonaut.h"

int main(int argc, const char * argv[])
{
    App *app = [[App alloc] init];
    Argonaut *argonaut = [[Argonaut alloc] init];

    [argonaut add:@"-h" target:argonaut action:@selector(printUsage:) description:@"Print help"];
    [argonaut add:@"--help" target:argonaut action:@selector(printUsage:) description:@"Print help"];
    [argonaut add:@"help" target:argonaut action:@selector(printUsage:) description:@"Print help"];

    [argonaut add:@"list windows" target:app action:@selector(listWindows:) description:@"List all windows"];
    [argonaut add:@"list tabs" target:app action:@selector(listTabs:) description:@"List all tabs"];
    [argonaut add:@"list tabs -w <id>" target:app action:@selector(listTabsInWindow:) description:@"List tabs in specific window"];
    [argonaut add:@"list links" target:app action:@selector(listTabsLinks:) description:@"List all tabs' link"];
    [argonaut add:@"list links -w <id>" target:app action:@selector(listTabsLinksInWindow:) description:@"List tabs' link in specific window"];


    [argonaut add:@"info" target:app action:@selector(printActiveTabInfo:) description:@"Print info for active tab"];
    [argonaut add:@"info -t <id>" target:app action:@selector(printTabInfo:) description:@"Print info for specific tab"];

    [argonaut add:@"open <url>" target:app action:@selector(openUrlInNewTab:) description:@"Open url in new tab"];
    [argonaut add:@"open <url> -n" target:app action:@selector(openUrlInNewWindow:) description:@"Open url in new window"];
    [argonaut add:@"open <url> -i" target:app action:@selector(openUrlInNewIncognitoWindow:) description:@"Open url in new incognito window"];
    [argonaut add:@"open <url> -t <id>" target:app action:@selector(openUrlInTab:) description:@"Open url in specific tab"];
    [argonaut add:@"open <url> -w <id>" target:app action:@selector(openUrlInWindow:) description:@"Open url in new tab in specific window"];

    [argonaut add:@"close" target:app action:@selector(closeActiveTab:) description:@"Close active tab"];
    [argonaut add:@"close -w" target:app action:@selector(closeActiveWindow:) description:@"Close active window"];
    [argonaut add:@"close -t <id>" target:app action:@selector(closeTab:) description:@"Close specific tab"];
    [argonaut add:@"close -w <id>" target:app action:@selector(closeWindow:) description:@"Close specific window"];

    [argonaut add:@"reload" target:app action:@selector(reloadActiveTab:) description:@"Reload active tab"];
    [argonaut add:@"reload -t <id>" target:app action:@selector(reloadTab:) description:@"Reload specific tab"];

    [argonaut add:@"back" target:app action:@selector(goBackActiveTab:) description:@"Navigate back in active tab"];
    [argonaut add:@"back -t <id>" target:app action:@selector(goBackInTab:) description:@"Navigate back in specific tab"];

    [argonaut add:@"forward" target:app action:@selector(goForwardActiveTab:) description:@"Navigate forward in active tab"];
    [argonaut add:@"forward -t <id>" target:app action:@selector(goForwardInTab:) description:@"Navigate forward in specific tab"];

    [argonaut add:@"presentation" target:app action:@selector(enterPresentationModeWithActiveTab:) description:@"Enter presentation mode with the active tab"];
    [argonaut add:@"presentation -t <id>" target:app action:@selector(enterPresentationModeWithTab:) description:@"Enter presentation mode with a specific tab"];
    [argonaut add:@"presentation exit" target:app action:@selector(exitPresentationMode:) description:@"Exit presentation mode"];

    [argonaut add:@"size" target:app action:@selector(printActiveWindowSize:) description:@"Print size of active window"];
    [argonaut add:@"size -w <id>" target:app action:@selector(printWindowSize:) description:@"Print size of specific window"];
    [argonaut add:@"size <width> <height>" target:app action:@selector(setActiveWindowSize:) description:@"Set size of active window"];
    [argonaut add:@"size <width> <height> -w <id>" target:app action:@selector(setWindowSize:) description:@"Set size of specific window"];

    [argonaut add:@"position" target:app action:@selector(printActiveWindowPosition:) description:@"Print position of active window"];
    [argonaut add:@"position -w <id>" target:app action:@selector(printWindowPosition:) description:@"Print position of specific window"];
    [argonaut add:@"position <x> <y>" target:app action:@selector(setActiveWindowPosition:) description:@"Set position of active window"];
    [argonaut add:@"position <x> <y> -w <id>" target:app action:@selector(setWindowPosition:) description:@"Set position of specific window"];

    [argonaut add:@"source" target:app action:@selector(printSourceFromActiveTab:) description:@"Print source from active tab"];
    [argonaut add:@"source -t <id>" target:app action:@selector(printSourceFromTab:) description:@"Print source from specific tab"];

    [argonaut add:@"execute <javascript>" target:app action:@selector(executeJavascriptInActiveTab:) description:@"Execute javascript in active tab"];
    [argonaut add:@"execute <javascript> -t <id>" target:app action:@selector(executeJavascriptInTab:) description:@"Execute javascript in specific tab"];

    [argonaut add:@"chrome version" target:app action:@selector(printChromeVersion:) description:@"Print Chrome version"];
    [argonaut add:@"version" target:app action:@selector(printVersion:) description:@"Print application version"];


    if (![argonaut parse]) {
        printf("No matching handler found\n");
        return 1;
    }

    if (![app ready]) {
        return 1;
    }

    [argonaut run];

    return 0;
}
