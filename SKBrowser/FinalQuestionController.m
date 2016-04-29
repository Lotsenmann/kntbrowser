//
//  FinalQuestionController.m
//  SKBrowser
//
//  Created by Marco A. Hudelist on 01.08.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "FinalQuestionController.h"

@implementation FinalQuestionController

- (void)viewWillAppear:(BOOL)animated
{
    self.preferredBrowser.selectedSegmentIndex = 0;
    self.commentsTextview.text = @"";
}

- (IBAction)finish:(UIButton *)sender
{
    FinalQuestions *fq = [[FinalQuestions alloc] init];
    
    if (self.preferredBrowser.selectedSegmentIndex == 0) {
        fq.preferredBrowser = @"Normal";
    } else {
        fq.preferredBrowser = @"SKBrowser";
    }
    
    fq.comments = self.commentsTextview.text;
    
    [self.delegate dismissFinalQuestionControllerWith:fq];
}

@end
