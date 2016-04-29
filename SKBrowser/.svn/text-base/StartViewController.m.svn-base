//
//  StartViewController.m
//  CvCStudy
//
//  Created by Marco A. Hudelist on 09.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Handlers

// Start in Demo Mode Flipped
- (IBAction)startSkDemoSame:(UIButton *)sender
{
    [self.delegate demoSkBrowserSame];
}

// Start in Demo Mode Normal Browser
- (IBAction)startNormalDemo:(UIButton *)sender
{
    [self.delegate demoNormalBrowser];
}

// Start question demo mode
- (IBAction)startQuestionDemo:(UIButton *)sender
{
    [self.delegate demoQuestionaire];
}

// Start target display demo
- (IBAction)startTargetDisplayDemo:(UIButton *)sender
{
    [self.delegate demoTargetDisplay];
}

// User selected a mode
- (IBAction)modeSelected:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 1 && self.studyForm.hidden == NO) {
        [UIView animateWithDuration:0.2 animations:^{
            self.studyForm.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.studyForm.hidden = YES;
        }];
    } else if (sender.selectedSegmentIndex == 0 && self.studyForm.hidden == YES) {
        self.studyForm.hidden = NO;
        self.studyForm.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.studyForm.alpha = 1.0;
        }];
    }
}

// Starts a new trial
- (IBAction)startStudy:(UIButton *)sender
{
    InitalUserInformation *initUserInfo = [[InitalUserInformation alloc] init];
    
    initUserInfo.firstname = self.studyFirstname.text;
    initUserInfo.lastname = self.studyLastname.text;
    initUserInfo.age = self.studyAge.text.intValue;

    
    if (self.studyGender.selectedSegmentIndex == 0) {
        initUserInfo.gender = gFemale;
    } else {
        initUserInfo.gender = gMale;
    }
    
    initUserInfo.occupation = self.studyOccupation.text;
    
    if (self.studyFirstInterface.selectedSegmentIndex == 0) {
        initUserInfo.initialBrowser = ibNormal;
    } else {
        initUserInfo.initialBrowser = ibSkBrowser;
    }
    
    if (self.studyFirstTargetSet.selectedSegmentIndex == 0) {
        initUserInfo.firstTargetSet = 1;
    } else {
        initUserInfo.firstTargetSet = 2;
    }
    
    initUserInfo.email = self.studyEmail.text;
    
    [self.delegate startStudy:initUserInfo];
}

@end
