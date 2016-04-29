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
