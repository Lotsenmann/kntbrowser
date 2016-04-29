//
//  GestureFFFRView.h
//  EndoApp
//
//  Created by Marco A. Hudelist on 28.04.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureFFFRView : UIView

@property NSInteger level;

- (void)setCenterPoint:(CGPoint)centerPoint;
- (void)userDraggedTo:(CGPoint)fingerPoint;

@end
