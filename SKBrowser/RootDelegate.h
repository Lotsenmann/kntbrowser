//
//  RootDelegate.h
//  SKBrowser
//
//  Created by Marco A. Hudelist on 25.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InitalUserInformation.h"
#import "Questionaire.h"
#import "FinalQuestions.h"

@protocol RootDelegate <NSObject>

- (void)dismissStartViewController;
- (void)dismissSkBrowserController;
- (void)dismissSkBrowserControllerWithFrameNr:(CGFloat)framenumber;
- (void)dismissNormalBrowserWithFrameNr:(CGFloat)framenumber;
- (void)dismissQuestionViewController;
- (void)dismissQuestionViewControllerWith:(Questionaire *)questionaire;
- (void)dismissTargetDisplayController;
- (void)dismissFinalQuestionControllerWith:(FinalQuestions *)fq;

- (void)demoSkBrowserSame;
- (void)demoNormalBrowser;

- (void)demoQuestionaire;
- (void)demoTargetDisplay;
- (void)dismissDemo;

- (void)startStudy:(InitalUserInformation *)initUserInfo;


@end
