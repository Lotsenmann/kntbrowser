//
//  StartViewController.h
//  CvCStudy
//
//  Created by Marco A. Hudelist on 09.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InitalUserInformation.h"

#import "RootDelegate.h"

@interface StartViewController : UIViewController

@property id<RootDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *studyForm;
@property (weak, nonatomic) IBOutlet UITextField *studyFirstname;
@property (weak, nonatomic) IBOutlet UITextField *studyLastname;
@property (weak, nonatomic) IBOutlet UITextField *studyAge;
@property (weak, nonatomic) IBOutlet UISegmentedControl *studyGender;
@property (weak, nonatomic) IBOutlet UITextField *studyMatNr;
@property (weak, nonatomic) IBOutlet UITextField *studyOccupation;
@property (weak, nonatomic) IBOutlet UITextField *studyEmail;
@property (weak, nonatomic) IBOutlet UISegmentedControl *studyFirstInterface;
@property (weak, nonatomic) IBOutlet UISegmentedControl *studyFirstTargetSet;

@end
