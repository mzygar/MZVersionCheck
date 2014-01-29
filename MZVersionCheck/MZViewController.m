//
//  MZViewController.m
//  MZVersionCheck
//
//  Created by Michal Zygar on 29.01.2014.
//  Copyright (c) 2014 Michal Zygar. All rights reserved.
//

#import "MZViewController.h"
#import "MZVersionCheck.h"
@interface MZViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UILabel *availableVersion;

@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MZVersionCheck *updateCheck = [MZVersionCheck appstoreVersionCheck];
    self.appVersion.text = updateCheck.currentVersion;

    __weak typeof(self) wself = self;

    [updateCheck checkForUpdates: ^(NSString *remoteVersion, BOOL isNewVersionAvailable, NSString *applicationURL) {
         if (remoteVersion)
         {
             wself.availableVersion.text = remoteVersion;
             if (isNewVersionAvailable)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Update needed" message:@"New version is available" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
             }
         }
         else
         {
             wself.availableVersion.text = @"no data(error or not found)";
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end