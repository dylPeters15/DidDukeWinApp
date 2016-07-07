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

UITextField *yesNoTextField;
UIButton *scoreButton;
NSURL *scoreURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    yesNoTextField = [[UITextField alloc] init];
    scoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [yesNoTextField setText:@"N/A"];
    [scoreButton setTitle:@"0-0" forState:UIControlStateNormal];
    
    [yesNoTextField setBackgroundColor:[UIColor clearColor]];
    [scoreButton setBackgroundColor:[UIColor clearColor]];
    
    [yesNoTextField setTextAlignment:NSTextAlignmentCenter];
    [yesNoTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [yesNoTextField setUserInteractionEnabled:false];
    [scoreButton addTarget:self action:@selector(scoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [yesNoTextField sizeToFit];
    [yesNoTextField sizeToFit];
    
    [self.view addSubview:yesNoTextField];
    [self.view addSubview:scoreButton];
    
    [self applyConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeDelegateObservers) name:UIApplicationWillTerminateNotification object:nil];
}

- (void) removeDelegateObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void) updateInfo{
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] hasWinLossInfo]){
        [yesNoTextField setText:[(AppDelegate *)[[UIApplication sharedApplication] delegate] getWinLossInfo]];
        if ([[yesNoTextField.text lowercaseString] isEqualToString:@"yes"]){
            [yesNoTextField setTextColor:[UIColor greenColor]];
        } else if ([[yesNoTextField.text lowercaseString] isEqualToString:@"no"]){
            [yesNoTextField setTextColor:[UIColor redColor]];
        } else {
            [yesNoTextField setTextColor:[UIColor blackColor]];
        }
    } else {
        [yesNoTextField setText:@""];
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
}

- (void) applyConstraints {
    [self.view setTranslatesAutoresizingMaskIntoConstraints:false];
    [yesNoTextField setTranslatesAutoresizingMaskIntoConstraints:false];
    [scoreButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //set size
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0.0]];
    
    //set layout
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:yesNoTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:yesNoTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    //set font size
    [yesNoTextField setMinimumFontSize:1];
    [yesNoTextField setFont:[UIFont fontWithName:yesNoTextField.font.fontName size:200]];
    [yesNoTextField setAdjustsFontSizeToFitWidth:true];
    [scoreButton sizeToFit];
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
