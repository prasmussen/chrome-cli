# chrome-cli

## Overview

chrome-cli is a command line utility for controlling Google Chrome compatible browsers on OS X.
It is a native binary that uses the Scripting Bridge to communicate with Chrome.
chrome-cli has been tested with the following browsers:

- Chrome
- Chrome Canary
- Chromium
- Brave
- Vivaldi
- Edge
- Arc

### Other browsers

By default chrome-cli communicates with Chrome, but you can use it with other browsers by settings
the `CHROME_BUNDLE_IDENTIFIER` environment variable. I.e. to use chrome-cli with Brave you can run the following command:

```bash
CHROME_BUNDLE_IDENTIFIER="com.brave.Browser" chrome-cli list tabs
```

Check the [scripts directory](scripts) for some convenient wrappers.

#### How do I find the bundle identifier?

The following command will print out the bundle identifier for Brave

```bash
mdls -name kMDItemCFBundleIdentifier -raw /Applications/Brave\ Browser.app
```

## Installation

#### Homebrew

```bash
brew install chrome-cli
```

This will install:

- chrome-cli
- chrome-canary-cli
- chromium-cli
- brave-cli
- vivaldi-cli
- edge-cli
- arc-cli

## JavaScript execution and viewing source

To execute javascript or to view a tab's source you must first enable `View > Developer > Allow JavaScript from Apple Events`.
More details [here](https://www.chromium.org/developers/applescript). Thanks to @kevinfrommelt and @paulp for providing this information.

## Usage

    chrome-cli -h  (Print help)
    chrome-cli --help  (Print help)
    chrome-cli help  (Print help)
    chrome-cli list windows  (List all windows)
    chrome-cli list tabs  (List all tabs)
    chrome-cli list tabs -w <id>  (List tabs in specific window)
    chrome-cli list links  (List all tabs' link)
    chrome-cli list links -w <id>  (List tabs' link in specific window)
    chrome-cli info  (Print info for active tab)
    chrome-cli info -t <id>  (Print info for specific tab)
    chrome-cli open <url>  (Open url in new tab)
    chrome-cli open <url> -n  (Open url in new window)
    chrome-cli open <url> -i  (Open url in new incognito window)
    chrome-cli open <url> -t <id>  (Open url in specific tab)
    chrome-cli open <url> -w <id>  (Open url in new tab in specific window)
    chrome-cli close  (Close active tab)
    chrome-cli close -w  (Close active window)
    chrome-cli close -t <id>  (Close specific tab)
    chrome-cli close -w <id>  (Close specific window)
    chrome-cli reload  (Reload active tab)
    chrome-cli reload -t <id>  (Reload specific tab)
    chrome-cli back  (Navigate back in active tab)
    chrome-cli back -t <id>  (Navigate back in specific tab)
    chrome-cli forward  (Navigate forward in active tab)
    chrome-cli forward -t <id>  (Navigate forward in specific tab)
    chrome-cli activate -t <id>  (Activate specific tab)
    chrome-cli activate -t <id> --focus  (Activate tab and bring its window to the front)
    chrome-cli activate -t <windowId>:<id>  (Activate specific tab in a specific window — useful with multiple profiles)
    chrome-cli activate -t <windowId>:<id> --focus  (Activate specific tab and bring that window to the front)
    chrome-cli presentation  (Enter presentation mode with the active tab)
    chrome-cli presentation -t <id>  (Enter presentation mode with a specific tab)
    chrome-cli presentation exit  (Exit presentation mode)
    chrome-cli size  (Print size of active window)
    chrome-cli size -w <id>  (Print size of specific window)
    chrome-cli size <width> <height>  (Set size of active window)
    chrome-cli size <width> <height> -w <id>  (Set size of specific window)
    chrome-cli position  (Print position of active window)
    chrome-cli position -w <id>  (Print position of specific window)
    chrome-cli position <x> <y>  (Set position of active window)
    chrome-cli position <x> <y> -w <id>  (Set position of specific window)
    chrome-cli source  (Print source from active tab)
    chrome-cli source -t <id>  (Print source from specific tab)
    chrome-cli execute <javascript>  (Execute javascript in active tab)
    chrome-cli execute <javascript> -t <id>  (Execute javascript in specific tab)
    chrome-cli chrome version  (Print Chrome version)
    chrome-cli version  (Print application version)

#### JSON output

You can set the environment variable `OUTPUT_FORMAT` to json to get json output.
For example:

```
$ OUTPUT_FORMAT=json chrome-cli list tabs
{
  "tabs" : [
    {
      "id" : 1869578516,
      "title" : "Lobsters",
      "url" : "https://lobste.rs/",
      "windowId" : 1869578514,
      "windowName" : "Lobsters"
    }
  ]
}
```

## Examples

###### List tabs

    $ chrome-cli list tabs
    [57] Inbox (1) - foo.bar@gmail.com - Gmail
    [2147] My Drive - Google Drive
    [2151] GitHub
    [2161]
    [2155] Hacker News

If you have multiple Chrome windows (e.g., across profiles), tab listings include window ids like:

    [1001:2161] Example Tab Title

You can then activate the tab specifically with:

    chrome-cli activate -t 1001:2161

###### Print tab info

    $ chrome-cli info -t 2161
    Id: 2162
    Title:
    Url: http://httpbin.org/ip
    Loading: No

###### Print tab source

    $ chrome-cli source -t 2161
    <html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">{
      "origin": "1.2.3.4"
    }</pre></body></html>

###### Extract information from page

    $ chrome-cli execute '(function() { var nodes = document.querySelectorAll(".title a"); var titles = []; for (var i = 0; i < 5; i++) { titles.push(nodes[i].innerHTML) } return titles.join("\n"); })();' -t 2155
    High-Speed Trading Isn't About Efficiency—It's About Cheating
    The terrifying surveillance case of Brandon Mayfield
    Google turns on "Download Gmail Archive" feature
    Learning to Code vs Learning Computer Science
    Show HN: Crushify.org
