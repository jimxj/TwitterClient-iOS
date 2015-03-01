//
//  CenterViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/26/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "CenterViewController.h"
#import "LeftViewController.h"
#import "UserProfileViewController.h"
#import "MainViewController.h"
#import "TWUser.h"
#import "UserProfileViewController.h"

@interface CenterViewController ()

@property (nonatomic, strong) LeftViewController *leftViewController;

@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, strong) UIPanGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic, strong) UINavigationController *homeTimelineController;

@property (nonatomic, strong) UserProfileViewController *userProfileViewController;

@end

@implementation CenterViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _tapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) manuDidChanged:(TwitterManuItem) manuItem {
    switch (manuItem) {
        case TwitterManuItemUserProfile: {
            [self setViewController:self.userProfileViewController atIndex:1];
            break;
        }
        case TwitterManuItemHomeTimeLine: {
            [self setViewController:self.homeTimelineController atIndex:1];
            break;
        }
        default:
            break;
    }
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self initLeftViewController];
        self.originalCenter = self.rightViewController.view.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        CGFloat newX = self.originalCenter.x + translation.x;
        if(newX >= self.view.center.x) {
            self.rightViewController.view.center = CGPointMake(newX, self.originalCenter.y);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:0 animations:^{
            if(self.rightViewController.view.center.x < self.originalCenter.x) {
                self.rightViewController.view.center = CGPointMake(self.view.center.x, self.originalCenter.y);
            } else {
               self.rightViewController.view.center = CGPointMake(self.view.center.x * 2.5, self.originalCenter.y);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void) initLeftViewController {
    if(!_leftViewController) {
        _leftViewController = [[LeftViewController alloc] init];        
        [self setViewController:_leftViewController atIndex:0];
        _leftViewController.view.center = self.view.center;
        _leftViewController.manuHandler = self;
    }
}

- (void) setViewController:(UIViewController *) viewController atIndex:(NSInteger)index {
    if([viewController class] == [self.rightViewController class]) {
        return;
    }
    
//    [self.view insertSubview:viewController.view atIndex:[self.view.subviews count]];
//    [self addChildViewController:viewController];
//    
//    //right
//    if(1 == index) {
//        if(self.rightViewController) {
//            [self transitionFromViewController:self.rightViewController toViewController:viewController duration:0.2 options:0 animations:^{
//                // Do any fancy animation you like
//            } completion:^(BOOL finished) {
//                [self.rightViewController removeFromParentViewController];
//                [self.rightViewController.view removeFromSuperview];
//                [self.rightViewController.view  removeGestureRecognizer:self.tapGestureRecognizer];
//            }];
//        }
//        
//        self.rightViewController = viewController;
//        [self.rightViewController.view addGestureRecognizer:self.tapGestureRecognizer];
//    }
//    
//    [viewController didMoveToParentViewController:self];
    
    if(1 == index) {
        if(self.rightViewController) {
            [self.rightViewController removeFromParentViewController];
            [self.rightViewController.view removeFromSuperview];
            [self.rightViewController.view  removeGestureRecognizer:self.tapGestureRecognizer];
        }
        
        self.rightViewController = viewController;
        [self.rightViewController.view addGestureRecognizer:self.tapGestureRecognizer];
    }
    
    [self.view insertSubview:viewController.view atIndex:index];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    if(1 == index) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:0 animations:^{
            self.rightViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (UINavigationController *) homeTimelineController {
    if(!_homeTimelineController) {
        _homeTimelineController = [[UINavigationController alloc] init];
        _homeTimelineController.navigationBar.translucent = YES;
        _homeTimelineController.navigationBar.barStyle = UIBarStyleBlack;
        _homeTimelineController.navigationBar.tintColor = [UIColor whiteColor];
        _homeTimelineController.navigationBar.backgroundColor = [UIColor blueColor];
        [_homeTimelineController setViewControllers:@[[[MainViewController alloc] init]]];
    }
    
    return _homeTimelineController;
}

- (UserProfileViewController *) userProfileViewController {
    if(!_userProfileViewController) {
        _userProfileViewController = [[UserProfileViewController alloc] initWithUserScreenName:[TWUser currentUser].screenName];
    }
    
    return _userProfileViewController;
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
