//
//  ViewController.m
//  Did Duke Win
//
//  Created by Dylan Peters on 7/6/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

UITextView *yesNoTextView;
UIButton *scoreButton;
NSURL *scoreURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    yesNoTextView = [[UITextView alloc] init];
    scoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [yesNoTextView setText:@"N/A"];
    [scoreButton setTitle:@"0-0" forState:UIControlStateNormal];
    
    [yesNoTextView setBackgroundColor:[UIColor clearColor]];
    [scoreButton setBackgroundColor:[UIColor clearColor]];
    
    [yesNoTextView setTextAlignment:NSTextAlignmentCenter];
    
    [yesNoTextView setUserInteractionEnabled:false];
    [scoreButton addTarget:self action:@selector(scoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [yesNoTextView sizeToFit];
    [yesNoTextView sizeToFit];
    
    [self.view addSubview:yesNoTextView];
    [self.view addSubview:scoreButton];
    
    [self applyConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) updateInfo{
    NSLog(@"22222");
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] hasWinLossInfo]){
        [yesNoTextView setText:[(AppDelegate *)[[UIApplication sharedApplication] delegate] getWinLossInfo]];
    } else {
        [yesNoTextView setText:@""];
    }
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] hasScoreInfo]){
        [scoreButton setTitle:[(AppDelegate *)[[UIApplication sharedApplication] delegate] getScoreInfo] forState:UIControlStateNormal];
    } else {
        [scoreButton setTitle:@"" forState:UIControlStateNormal];
    }
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] hasScoreURL]){
        [scoreButton setUserInteractionEnabled:true];
        scoreURL = [(AppDelegate *)[[UIApplication sharedApplication] delegate] getScoreURL];
    } else {
        [scoreButton setUserInteractionEnabled:false];
    }
}

-(void) scoreButtonClicked:(UIButton *)button{
    [[UIApplication sharedApplication] openURL:scoreURL];
    NSLog(@"score button clicked");
}

- (void) applyConstraints {
    [self.view setTranslatesAutoresizingMaskIntoConstraints:false];
    [yesNoTextView setTranslatesAutoresizingMaskIntoConstraints:false];
    [scoreButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //set size
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0.0]];
    
    //set layout
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:yesNoTextView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    //set font size
    
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
