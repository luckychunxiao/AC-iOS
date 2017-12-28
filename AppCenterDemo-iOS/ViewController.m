//
//  ViewController.m
//  AppCenterDemo-iOS
//
//  Created by HockeyAppSupporter on 02/12/2017.
//  Copyright © 2017 HockeyAppSupporter. All rights reserved.
//

#import "ViewController.h"
@import AppCenterCrashes;
@import AppCenterAnalytics;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)trackEvent:(id)sender {
    
    [MSAnalytics trackEvent:@"TrackEvent"];
    [MSAnalytics trackEvent:@"TrackEventWithProperty" withProperties:@{ @"Name":@"Kevin",
                                                                        @"City":@"Wuxi",
                                                                        @"Country":@"China",
                                                                        @"Height":@"173",
                                                                        @"Weigth":@"68",
                                                                        //@"Tel":@"+86 132",
                                                                        //@"Age":@"26"
                                                                        
                                                                        
                                                                       }];
    
}


- (IBAction)triggerCrash:(id)sender {
    
    //[MSCrashes generateTestCrash];
    
    NSException *exception = [[NSException alloc]initWithName:@"Exception" reason:@"Crash Test" userInfo:nil];
    @throw exception;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
