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

    [argonaut add:@"info" target:app action:@selector(printActiveTabInfo:) description:@"Print info for active tab"];
    [argonaut add:@"info -t <id>" target:app action:@selector(printTabInfo:) description:@"Print info for specific tab"];

    [argonaut add:@"open <url>" target:app action:@selector(openUrlInNewTab:) description:@"Open url in new tab"];
    [argonaut add:@"open <url> -n" target:app action:@selector(openUrlInNewWindow:) description:@"Open url in new window"];
    [argonaut add:@"open <url> -n -i" target:app action:@selector(openUrlInNewIncognitoWindow:) description:@"Open url in new incognito window"];
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

    [argonaut add:@"source" target:app action:@selector(printSourceFromActiveTab:) description:@"Print source from active tab"];
    [argonaut add:@"source -t <id>" target:app action:@selector(printSourceFromTab:) description:@"Print source from specific tab"];

    [argonaut add:@"execute <javascript>" target:app action:@selector(executeJavascriptInActiveTab:) description:@"Execute javascript in active tab"];
    [argonaut add:@"execute <javascript> -t <id>" target:app action:@selector(executeJavascriptInTab:) description:@"Execute javascript in specific tab"];

    [argonaut add:@"chrome version" target:app action:@selector(printChromeVersion:) description:@"Print Chrome version"];


    if (![argonaut parse]) {
        printf("No matching handler found\n\n");
        [argonaut printUsage];
    }

    return 0;
}
