//
//  LoginViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "CenterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(UIButton *)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(TWUser *user, NSError *error) {
        if(user) {
            NSLog(@"Welcome %@", user.name);
            
            //Modally present tweet view
            CenterViewController *centerVC = [[CenterViewController alloc] init];
            [centerVC manuDidChanged:TwitterManuItemHomeTimeLine];
            
            [self presentViewController:centerVC animated:YES completion:nil ];
        } else {
            //present error view
        }
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
