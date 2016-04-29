//
//  Questionaire.m
//  SKBrowser
//
//  Created by Marco A. Hudelist on 31.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "Questionaire.h"

@implementation Questionaire

- (id)init
{
    if (self = [super init]) {
        self.questions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
