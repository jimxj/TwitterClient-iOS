//
//  MainViewController.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/19/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSString *timelineType;

- (instancetype) initWithTimelineType:(NSString *) timelineType;

@end
