//
//  SKBrowserQuestion.m
//  SKBrowser
//
//  Created by Marco A. Hudelist on 04.08.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "SKBrowserQuestion.h"

@implementation SKBrowserQuestion

- (NSString *)commentText
{
    return self.browserComment.text;
}

- (void)setCommentText:(NSString *)commentText
{
    self.browserComment.text = commentText;
}

@end
