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

#import "WeightedQuestion.h"

@interface WeightedQuestion ()
{
    NSString *_titleText;
    NSString *_description;
    NSString *_lowText;
    NSString *_highText;
}

@end

@implementation WeightedQuestion

#pragma mark - Initialization

- (void)customInit
{
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.questionTitle.text = _titleText;
    self.questionText.text = _description;
    self.weightHighLabel.text = _highText;
    self.weightLowLabel.text = _lowText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Properties

- (NSString *)titleText
{
    return _titleText;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    
    if (self.questionTitle != nil) {
        self.questionTitle.text = _titleText;
    }
}

- (NSString *)description
{
    return _description;
}

- (void)setDescription:(NSString *)description
{
    _description = description;
    
    if (self.questionText != nil) {
        self.questionText.text = _description;
    }
}

- (NSString *)lowText
{
    return _lowText;
}

- (void)setLowText:(NSString *)lowText
{
    _lowText = lowText;
    
    if (self.weightLowLabel != nil) {
        self.weightLowLabel.text = lowText;
    }
}

- (NSString *)highText
{
    return _highText;
}

- (void)setHighText:(NSString *)highText
{
    _highText = highText;
    
    if (self.weightHighLabel != nil) {
        self.weightHighLabel.text = _highText;
    }
}

- (NSInteger)value
{
    return (int)self.weightSlider.value;
}

#pragma mark - Action Handlers

- (IBAction)userChangedWeight:(UISlider *)sender
{
    self.weightLabel.text = [NSString stringWithFormat:@"%d", (int)self.weightSlider.value];
}

@end
