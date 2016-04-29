/*
 *
 * Copyright (c) 2016, Marco A. Hudelist. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301 USA
 */

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
