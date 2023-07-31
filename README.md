# vendr-whitelisting-template

open-sourced this on my own accord, this was not planned by anyone but me ##wtmgtd

### Issues and Pull Requests are more than welcome, but please abide by correct styling (Unsure whether I abide by it myself, but improvements are welcome.)

[Roblox/lua-style-guide](https://roblox.github.io/lua-style-guide/) |
[LuaRocks/lua-style-guide](https://github.com/luarocks/lua-style-guide)

[main](./stable/MainModule.lua)  **or** [experimental](./experimental/MainModule.lua)

## Features
	- main
		checks whether a user is whitelisted or not
	- experimental
		checks whether a user is whitelisted or not
		display a modal to the user based off an external webserver's status

## Reasoning

The use of Vendr has been on the rise recently, and after coming across these files, I decided that it would be best to publish them with some additions that were made for a specific purpose [(found here)](./experimental/MainModule.lua), but there's no harm in posting them at all.

## Usage

This is for you to use in your products, and setup is pretty trivial, but just as a disclaimer, this will not be obfuscated. If you do not want to use the cloud provided solution, then please download the source in the [releases](https://github.com/dr4wn/vendr-whitelist-tempalte/releases) tab and follow your own procedure.

Obfuscations do not support any [Lua-U](https://github.com/Roblox/luau) features! This includes any type checking shown below in the examples.

If you are following the _experimental_ release, then setting up a file on an accessible web-server is recommended for the ability to display modals to customers. The .json file to display modals to users is available [here](./demo/status_demo.json). Uploading & configuring thisto a website and replacing the `statusLink` variable in [MainModule.lua](./experimental/MainModule.lua#L9) to your server of choice will ensure your whitelist is running properly. If you do not want this, fall back to [stable](./stable/MainModule.lua).

## Example Usage (Stable):

```lua
local whitelist: table = require(14256432357)
```

```lua
local whitelist = require(14256432357)
local placeId: number = game.PlaceId
local hubId: number = 1
local productName: string = "example"

local response: table = whitelist.getLicense(placeId, hubId, productName)

if not response.licenseInfo.licensed then
	-- handle whitelist rejections here
	return
end
```

## Example Usage (Experimental):
⚠️ Does not function since it cannot obtain a valid URL to parse data through! If you want interactive modals, please copy the experimental file and make changes yourself.
```lua
local whitelist = require(14256427992)
```


```lua
local whitelist = require(14256427992)
local placeId: number = game.PlaceId
local hubId: number = 1
local productName: string = "example"

local response: table = whitelist.getLicense(placeId, hubId, productName)

local modal = {
	closable = response.modalInfo.closable,
	title = response.modalInfo.title,
	message = response.modalInfo.message,
	hint = response.modalInfo.hint,
	iconToShow = response.modalInfo.icon,
	footerText = response.modalInfo.footerText,
	footerLink = response.modalInfo.footerLink
}

-- Allows you to remotely alert users of new changes,
-- updates, etc.

if not response.licenseInfo.licensed then
	-- handle whitelist rejections here
	return
end
```
## Author 

**vendr-licensing-template** © [dr4wn](https://github.com/dr4wn).  
Authored and maintained by dr4wn.

## License (MIT)

View it [here](https://opensource.org/license/mit/).

Copyright 2023 i'm goated™

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
