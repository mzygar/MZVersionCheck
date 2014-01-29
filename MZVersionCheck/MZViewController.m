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
@property (nonatomic, strong) NSString *appUrl;
@property (weak, nonatomic) IBOutlet UIButton *installUpdateButton;
- (IBAction)installNewVersion:(id)sender;
@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString* betaOrEnterprisePlistUrl=@"<Upload Sample.plist file somewhere>";
//  MZVersionCheck *updateCheck = [MZVersionCheck plistVersionCheckAtUrl:betaOrEnterprisePlistUrl];
    MZVersionCheck *updateCheck = [MZVersionCheck appstoreVersionCheck];
    self.appVersion.text = updateCheck.currentVersion;

    __weak typeof(self) wself = self;

    [updateCheck checkForUpdates: ^(NSString *remoteVersion, BOOL isNewVersionAvailable, NSString *applicationURL) {
         if (remoteVersion)
         {
             wself.availableVersion.text = remoteVersion;
         }
         else
         {
             wself.availableVersion.text = @"no data(error or not found)";
         }
         if (isNewVersionAvailable)
         {
             [[[UIAlertView alloc] initWithTitle:@"Update needed" message:@"New version is available" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
             self.appUrl = applicationURL;
         }
         else
         {
             wself.installUpdateButton.hidden = YES;
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)installNewVersion:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appUrl]];
}

@end