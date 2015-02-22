//
//  TWNewTweetViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/21/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TWNewTweetViewController.h"
#import "TWUser.h"
#import "UIImageView+AFNetworking.h"

@interface TWNewTweetViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;


@end

@implementation TWNewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    TWUser *currentUser = [TWUser currentUser];
    [self.userNameLabel setText:currentUser.name];
    [self.screenNameLabel setText:currentUser.screenName];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    
    self.tweetTextView.delegate = self;
    [self.tweetTextView setReturnKeyType:UIReturnKeyDone];
    [self.tweetTextView setText:@"What's happening..."];
    [self.tweetTextView setTextColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.tweetTextView.textColor == [UIColor lightGrayColor]) {
        self.tweetTextView.text = @"";
        self.tweetTextView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView {
    if(self.tweetTextView.text.length == 0){
        self.tweetTextView.textColor = [UIColor lightGrayColor];
        self.tweetTextView.text = @"What's happening...";
        [self.tweetTextView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.tweetTextView.text.length == 0){
            self.tweetTextView.textColor = [UIColor lightGrayColor];
            self.tweetTextView.text = @"List words or terms separated by commas";
            [self.tweetTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
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