//
//  MZVersionCheck.h
//  MZVersionCheck
//
//  Created by Michal Zygar on 29.01.2014.
//  Copyright (c) 2014 Michal Zygar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZVersionCheck : NSObject

@property (readonly) NSString *currentVersion;

+ (instancetype)appstoreVersionCheck;

+ (instancetype)plistVersionCheckAtUrl:(NSString *)urlString;

- (void)checkForNewVersion:( void (^)(BOOL isNewVersionAvailable, NSString *availableVersion) )completionBlock;
- (void)checkForUpdates:( void (^)(NSString *remoteVersion, BOOL isNewVersionAvailable, NSString *applicationURL) )completionBlock;
@end