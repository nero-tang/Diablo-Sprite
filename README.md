# Diablo Sprite
Diablo Sprite is a lightweight iOS app that aims at helping users to quickly lookup Diablo III profiles.

**IMPORTANT**: This app requires a valid Diablo III community API key, which can be applied at https://dev.battle.net/

## Features
* Login with BattleTag, which will be cached for future reference.
* Support both seasonal and non-seasonal heroes.
* Separate views for Stats, Items & Skills.
* Tooltip is supported for items and skills.

## Requirements
* Xcode 6.1
* iOS 7.0+

## Usage
* Clone or download this repo.
* Replace `#define API_KEY @"API KEY"` with your own API key in `AD3Defines.h`.
* Build and run!

## Screenshots
![](https://github.com/nero-tang/Diablo-Sprite/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%20Sep%2022%2C%202014%2C%206.35.39%20PM.png)
![](https://github.com/nero-tang/Diablo-Sprite/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%20Sep%2022%2C%202014%2C%206.36.13%20PM.png)
![](https://github.com/nero-tang/Diablo-Sprite/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%20Sep%2022%2C%202014%2C%206.36.22%20PM.png)
![](https://github.com/nero-tang/Diablo-Sprite/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%20Sep%2022%2C%202014%2C%206.36.41%20PM.png)

## Dependencies
* AFNetworking
* SDWebImage
* MBProgessHUD

## LICENSE
The MIT License (MIT)

Copyright (c) 2014-2015 Yufei Tang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
