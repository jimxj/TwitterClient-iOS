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
#import "TwitterClient.h"

@interface TWNewTweetViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, strong) UILabel *tweetCharCountLabel;

@end

@implementation TWNewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tweetCharCountLabel = [[UILabel alloc] init];
    self.tweetCharCountLabel.textAlignment = NSTextAlignmentRight;
    [self.tweetCharCountLabel setText:@"140"];
    self.navigationItem.titleView = self.tweetCharCountLabel;
    [self.tweetCharCountLabel sizeToFit];
    [self.tweetCharCountLabel setFont:[UIFont systemFontOfSize:12]];
    [self.tweetCharCountLabel setTextColor:[UIColor lightGrayColor]];
    //self.navigationItem.title = @"140";
    
    TWUser *currentUser = [TWUser currentUser];
    [self.userNameLabel setText:currentUser.name];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", currentUser.screenName]];
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
    if(self.tweetTextView.text.length) {
        [[TwitterClient sharedInstance] updateStatus:self.tweetTextView.text WithCompletion:^(TWTweet *newTweet, NSError *error) {
            if(newTweet) {
                [self.tweetCreationListner newTweet:newTweet];
            }
        }];
    }
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
    
    //self.navigationItem.title = [NSString stringWithFormat:@"%@", @(140 - self.tweetTextView.text.length)];
    [self.tweetCharCountLabel setText:[NSString stringWithFormat:@"%@", @(140 - self.tweetTextView.text.length)]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(![self isAcceptableTextLength:self.tweetTextView.text.length + text.length - range.length]) {
        return NO;
    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.tweetTextView.text.length == 0){
            self.tweetTextView.textColor = [UIColor lightGrayColor];
            self.tweetTextView.text = @"What's happening...";
            [self.tweetTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= 140;
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
