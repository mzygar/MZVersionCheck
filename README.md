# MZVersionCheck

Simple block-based component for checking if new version of the App is available. 

Component checks with the appstore version, based on bundle id. Example app is checking with facebook app.

Additionally, it can be used for test/enterprise distribution. If testing (or using Testflight), just upload and adjust `Sample.plist` file. If using enterprise distribution, provide url to your plist file.

## Info
* project uses ARC


## Installation

All you need to do is drop `MZVersionCheck` files into your project, and add `#include "MZVersionCheck.h"` to the top of classes that will use it.

## Example Usage

Here's the sample checking with current Appstore version:

``` objective-c
    MZVersionCheck *updateCheck = [MZVersionCheck appstoreVersionCheck];
    [updateCheck checkForUpdates: ^(NSString *remoteVersion, BOOL isNewVersionAvailable, NSString *applicationURL) {
    if(isNewVersionAvailable)
    {
    	[[UIApplication sharedApplication] openUrl:[NSURL URLWithString:applicationURL]];//opens app in Appstore
    }
    }];
```

Here's the sample checking with external .plist version (if you are using enterprise distro, you can also use `checkForUpdates:` to easily retrieve the application url.

```
 MZVersionCheck *updateCheck = [MZVersionCheck plistVersionCheckAtUrl:betaOrEnterprisePlistUrl];
 [updateCheck checkForNewVersion:^(BOOL isNewVersionAvailable, NSString *availableVersion) {
    
    }];
```

## Contact

Michał Zygar

- https://github.com/mzygar
- https://twitter.com/mzygar

Any suggestions/PRs would be appreciated

## License

MZVersionCheck is available under the MIT license.

Copyright © 2013 Michal Zygar.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.