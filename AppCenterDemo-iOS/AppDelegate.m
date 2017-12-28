//
//  AppDelegate.m
//  AppCenterDemo-iOS
//
//  Created by HockeyAppSupporter on 02/12/2017.
//  Copyright © 2017 HockeyAppSupporter. All rights reserved.
//

#import "AppDelegate.h"
@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;
@import AppCenterPush;
@import AppCenterDistribute;

@interface AppDelegate ()<MSCrashesDelegate,MSCrashHandlerSetupDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MSAppCenter start:@"45f030ed-cfe3-473e-b154-3c3d2553d747" withServices:@[
                                                                              [MSAnalytics class],
                                                                              [MSCrashes class],
                                                                              [MSPush class],
                                                                              [MSDistribute class]
                                                                              ]];
    [MSCrashes setDelegate:self];
    

    
    return YES;
}




// Before the Crash Report process. Popup query alert.
- (BOOL)crashes:(MSCrashes *)crashes shouldProcessErrorReport:(MSErrorReport *)errorReport{
    
    // Add these lines to ask user if he wants to send the crash report to AppCenter Server.
    // Reference: https://docs.microsoft.com/en-us/appcenter/sdk/crashes/ios#customize-your-usage-of-app-center-crashes
    [MSCrashes setUserConfirmationHandler:(^(NSArray<MSErrorReport *> *errorReports) {
        
        // Your code to present your UI to the user, e.g. an UIAlertController.
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Sorry about that!"
                                              message:@"Do you want to send an anonymous crash report so we can fix the issue?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"Don't send"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction *action) {
                                              [MSCrashes notifyWithUserConfirmation:MSUserConfirmationDontSend];
                                          }]];
        
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"Send"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              [MSCrashes notifyWithUserConfirmation:MSUserConfirmationSend];
                                          }]];
        
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"Always send"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              [MSCrashes notifyWithUserConfirmation:MSUserConfirmationAlways];
                                          }]];
        // Show the alert controller.
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        return YES; // Return YES if the SDK should await user confirmation, otherwise NO.
    })];
    
    return YES;
}

// Receive the Remote Push Notification and handle it.
// If the normal push notification is enabled as a silent with alert title or body, this delegate will be trigger twice, while the notification come in and user tap on the alert.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"Push Notification UserInfo: %@",userInfo);
    NSNumber *content_available = (NSNumber *)[[userInfo objectForKey:@"aps"] objectForKey:@"content-available"];
    BOOL isSilentPush = [content_available isEqual:@1]?true:false;
    if (isSilentPush) {
        NSLog(@"Silent Push");
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSLog(@"- Active");
    }else if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        NSLog(@"- Inactive");
    }else{
        NSLog(@"- Background");
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (NSArray<MSErrorAttachmentLog *> *)attachmentsWithCrashes:(MSCrashes *)crashes
                                             forErrorReport:(MSErrorReport *)errorReport{
    
    
    MSErrorAttachmentLog *attachment1 = [MSErrorAttachmentLog attachmentWithText:@"Hello world!" filename:@"CrashAttachments.txt"];
    //MSErrorAttachmentLog *attachment2 = [MSErrorAttachmentLog attachmentWithBinary:[@"Fake image" dataUsingEncoding:NSUTF8StringEncoding] filename:@"fake_image.jpeg" contentType:@"image/jpeg"];
    return @[ attachment1 ];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
