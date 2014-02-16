chrome-cli
==========


## Overview
chrome-cli is a command line utility for controlling Google Chrome on OS X.
It is a native binary that uses the Scripting Bridge to communicate
with Chrome.

## Installation
- Save the 'chrome-cli' binary to a location in your PATH (i.e. `/usr/local/bin/`)

### Downloads
- [chrome-cli-darwin-1.3.1-x64](https://drive.google.com/uc?id=0B3X9GlR6EmbnZU1hVGV4cUUtU0U)
- [canary-cli-darwin-1.3.1-x64](https://drive.google.com/uc?id=0B3X9GlR6EmbnRk5rS3k3NS16alU)

## Usage

```sh
# Print help
$ chrome-cli -h
# Print help
$ chrome-cli --help
# Print help
$ chrome-cli help
# List all windows
$ chrome-cli list windows
# List all tabs
$ chrome-cli list tabs
# List tabs in specific window
$ chrome-cli list tabs -w <id>
# List all tabs' link
$ chrome-cli list links
# List tabs' link in specific window
$ chrome-cli list links -w <id>
# Print info for active tab
$ chrome-cli info
# Print info for specific tab
$ chrome-cli info -t <id>
# Open url in new tab
$ chrome-cli open <url>
# Open url in new window
$ chrome-cli open <url> -n
# Open url in new incognito window
$ chrome-cli open <url> -i
# Open url in specific tab
$ chrome-cli open <url> -t <id>
# Open url in new tab in specific window
$ chrome-cli open <url> -w <id>
# Close active tab
$ chrome-cli close
# Close active window
$ chrome-cli close -w
# Close specific tab
$ chrome-cli close -t <id>
# Close specific window
$ chrome-cli close -w <id>
# Reload active tab
$ chrome-cli reload
# Reload specific tab
$ chrome-cli reload -t <id>
# Navigate back in active tab
$ chrome-cli back
# Navigate back in specific tab
$ chrome-cli back -t <id>
# Navigate forward in active tab
$ chrome-cli forward
# Navigate forward in specific tab
$ chrome-cli forward -t <id>
# Enter presentation mode with the active tab
$ chrome-cli presentation
# Enter presentation mode with a specific tab
$ chrome-cli presentation -t <id>
# Exit presentation mode
$ chrome-cli presentation exit
# Print source from active tab
$ chrome-cli source
# Print source from specific tab
$ chrome-cli source -t <id>
# Execute javascript in active tab
$ chrome-cli execute <javascript>
# Execute javascript in specific tab
$ chrome-cli execute <javascript> -t <id>
# Print Chrome version
$ chrome-cli chrome version
# Print application version
$ chrome-cli version
```

## Examples
###### List tabs

```sh
$ chrome-cli list tabs
[57] Inbox (1) - foo.bar@gmail.com - Gmail
[2147] My Drive - Google Drive
[2151] GitHub
[2161]
[2155] Hacker News
```

###### Print tab info

```sh
$ chrome-cli info -t 2161
Id: 2162
Title:
Url: http://httpbin.org/ip
Loading: No
```

###### Print tab source

```sh
$ chrome-cli source -t 2161
<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">{
  "origin": "1.2.3.4"
}</pre></body></html>
```

###### Extract information from page

```sh
$ chrome-cli execute '(function() { var nodes = document.querySelectorAll(".title a"); var titles = []; for (var i = 0; i < 5; i++) { titles.push(nodes[i].innerHTML) } return titles.join("\n"); })();' -t 2155
High-Speed Trading Isn't About Efficiency—It's About Cheating
The terrifying surveillance case of Brandon Mayfield
Google turns on "Download Gmail Archive" feature
Learning to Code vs Learning Computer Science
Show HN: Crushify.org
```
