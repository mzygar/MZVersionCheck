//
//  MZVersionCheck.m
//  MZVersionCheck
//
//  Created by Michal Zygar on 29.01.2014.
//  Copyright (c) 2014 Michal Zygar. All rights reserved.
//

#import "MZVersionCheck.h"


@interface MZVersionCheck ()
@property (nonatomic, strong) NSURL *enterprisePlistUrl;
@end


@implementation MZVersionCheck

+ (instancetype)appstoreVersionCheck
{
    MZVersionCheck *versionCheck = [MZVersionCheck new];
    return versionCheck;
}

+ (instancetype)plistVersionCheckAtUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    MZVersionCheck *versionCheck = [MZVersionCheck new];
    versionCheck.enterprisePlistUrl = url;
    return versionCheck;
}

- (void)checkForNewVersion:( void (^)(BOOL isNewVersionAvailable, NSString *availableVersion) )completionBlock
{
    [self checkForUpdates: ^(NSString *remoteVersion, BOOL isNewVersionAvailable, NSString *applicationURL) {
         NSString *currentVersion = self.currentVersion;
         BOOL isNewVersion = [self compareVersion:currentVersion toVersion:remoteVersion] == NSOrderedAscending;
         completionBlock(isNewVersion, remoteVersion);
     }];
}

- (void)checkForUpdates:( void (^)(NSString *remoteVersion, BOOL isNewVersionAvailable, NSString *applicationURL) )completionBlock
{
    if (self.enterprisePlistUrl)
    {
    }
    else
    {
        [self checkAppstoreVersion:completionBlock];
    }
}

- (void)checkAppstoreVersion:( void (^)(NSString *appstoreVersion, BOOL isNewVersionAvailable, NSString *appstoreUrl) )completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/US/lookup?bundleId=%@", [[NSBundle mainBundle] bundleIdentifier]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (!data || connectionError)
         {
             NSLog(@"unable to check appstore version: %@", [connectionError description]);
             completionBlock(nil, NO, nil);
             return;
         }
         NSError *err = nil;
         NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
         if (err)
         {
             NSLog(@"error: %@", err);
             completionBlock(nil, NO, nil);
             return;
         }
         if ([rootDict[@"resultCount"] intValue] > 0)
         {
             NSArray *results = rootDict[@"results"];
             NSDictionary *appDict = results[0];
             NSString *version = appDict[@"version"];
             NSString *appstoreURL = appDict[@"trackViewUrl"];
             NSLog(@"appstore version is: %@", version);
             BOOL isNewVersion = [self compareVersion:self.currentVersion toVersion:version] == NSOrderedAscending;

             completionBlock(version, isNewVersion, appstoreURL);
         }
     }];
}

- (NSComparisonResult)compareVersion:(NSString *)source toVersion:(NSString *)target
{
    NSArray *sourceComponents = [source componentsSeparatedByString:@"."];
    NSArray *targetComponents = [target componentsSeparatedByString:@"."];
    NSInteger maxLength = (sourceComponents.count > targetComponents.count ? sourceComponents.count : targetComponents.count);
    for (int i = 0; i < maxLength; i++)
    {
        NSInteger sVersion = 0;
        NSInteger tVersion = 0;

        if (i < sourceComponents.count)
        {
            //strip letters (like ver/v/b)
            NSString *sourceComponent = sourceComponents[i];
            sourceComponent = [sourceComponent stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
            sVersion = [sourceComponent integerValue];
        }
        if (i < targetComponents.count)
        {
            //strip letters (like ver/v/b)
            NSString *targetComponent = targetComponents[i];
            targetComponent = [targetComponent stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
            tVersion = [targetComponent integerValue];
        }

        if (sVersion != tVersion)
        {
            return [@(sVersion)compare : @(tVersion)];
        }
    }
    return NSOrderedSame;
}

- (NSString *)currentVersion
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = bundleInfo[@"CFBundleShortVersionString"];
    return currentVersion;
}

@end