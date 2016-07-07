//
//  ViewController.m
//  Did Duke Win
//
//  Created by Dylan Peters on 7/6/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import "ViewController.h"

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
    
    [self updateYesNo];
    [self updateScore];
    [self getScoreURL];
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

-(void) updateYesNo {
    NSURL *url = [NSURL URLWithString:@"https://www.diddukewin.com/"];
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    NSString *subString = [string substringWithRange:NSMakeRange([string rangeOfString:@"</p>"].location-2, 2)];
    UIColor *textColor = [UIColor blackColor];
    NSString *textString = @"";
    if ([[subString lowercaseString] isEqualToString:@"no"]){
        textColor = [UIColor redColor];
        textString = @"NO";
    } else {
        textColor = [UIColor greenColor];
        textString = @"YES";
    }
    [yesNoTextView setTextColor:textColor];
    [yesNoTextView setText:textString];
    NSLog(@"%@",subString);
}

-(void) updateScore {
    NSURL *url = [NSURL URLWithString:@"https://www.diddukewin.com/"];
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    NSRange range = [string rangeOfString:@"</a>"];
    NSUInteger index = range.location;
    while (index > 0 && [string characterAtIndex:index] != (NSUInteger)'>'){
        index--;
    }
    if (index != 0){
        index++;
    }
    NSString *substring = [string substringWithRange:NSMakeRange(index, range.location-index)];
    [scoreButton setTitle:substring forState:UIControlStateNormal];
    NSLog(@"%@",substring);
}

-(void) getScoreURL{
    NSURL *url = [NSURL URLWithString:@"https://www.diddukewin.com/"];
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    NSRange startingRange = [string rangeOfString:@"<a href='"];
    NSUInteger index = startingRange.location+startingRange.length;
    while (index < string.length && [string characterAtIndex:index] != (NSUInteger)39){
        index++;
    }
    NSString *substring = [string substringWithRange:NSMakeRange(startingRange.location+startingRange.length,index-startingRange.location-startingRange.length)];
    scoreURL = [NSURL URLWithString:substring];
    NSLog(@"%@",scoreURL.absoluteString);
}


- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
