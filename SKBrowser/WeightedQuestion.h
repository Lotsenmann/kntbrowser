//
//  WeightedQuestion.h
//  ColorVsConcept
//
//  Created by Marco A. Hudelist on 20.05.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightedQuestion : UIViewController

@property NSString *titleText;
@property NSString *description;
@property NSString *lowText;
@property NSString *highText;
@property (readonly) NSInteger value;

@property (weak, nonatomic) IBOutlet UILabel *questionTitle;
@property (weak, nonatomic) IBOutlet UITextView *questionText;
@property (weak, nonatomic) IBOutlet UILabel *weightLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UISlider *weightSlider;

@end
