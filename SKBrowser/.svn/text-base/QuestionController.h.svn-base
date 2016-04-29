//
//  QuestionController.h
//  ColorVsConcept
//
//  Created by Marco A. Hudelist on 16.04.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeightedQuestion.h"
#import "Question.h"
#import "Questionaire.h"
#import "SKBrowserQuestion.h"

#import "RootDelegate.h"

@class RootViewController;

@interface QuestionController : UIViewController
<NSXMLParserDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property id<RootDelegate> delegate;

@property BOOL demoMode;
@property BOOL showSKBrowserQuestion;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *generalQuestions;
@property (weak, nonatomic) IBOutlet UIView *interfaceQuestions;
@property (weak, nonatomic) IBOutlet UITableView *generalTableView;

- (void)resetQuestions;

@end
