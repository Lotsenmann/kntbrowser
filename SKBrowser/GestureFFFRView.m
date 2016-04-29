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

#import "GestureFFFRView.h"

@interface GestureFFFRView ()
{
    UIBezierPath *_line;
    
    UIImage *_fframeImage;
    UIImage *_ffImage;
    UIImage *_fffImage;
    UIImage *_ffffImage;
    
    UIImage *_frframeImage;
    UIImage *_frImage;
    UIImage *_frrImage;
    UIImage *_frrrImage;
    
    UIImageView *_background;
    UIImageView *_centerCircle;
    UIImageView *_indicator;
}

@end

@implementation GestureFFFRView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    // Background
    CGRect viewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _background = [[UIImageView alloc] initWithFrame:viewFrame]; // Just dummy size until real one is loaded in viewDidLoad
    _background.backgroundColor = [UIColor blackColor];
    _background.alpha = 0.5;
    [self addSubview:_background];
    
    // FF images
    _fframeImage = [UIImage imageNamed:@"indi_fframe"];
    _ffImage = [UIImage imageNamed:@"indi_ff"];
    _fffImage = [UIImage imageNamed:@"indi_fff"];
    _ffffImage = [UIImage imageNamed:@"indi_ffff"];
    
    // FR images
    _frframeImage = [UIImage imageNamed:@"indi_frframe"];
    _frImage = [UIImage imageNamed:@"indi_fr"];
    _frrImage = [UIImage imageNamed:@"indi_frr"];
    _frrrImage = [UIImage imageNamed:@"indi_frrr"];

    // Indicator
    _indicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _indicator.hidden = YES;
    [self addSubview:_indicator];
    
    // Circle
    _centerCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indi_centercircle"]];
    _centerCircle.frame = CGRectMake(0, 0, 70, 70);
    _centerCircle.hidden = YES;
    [self addSubview:_centerCircle];

    // Line
    _line = [[UIBezierPath alloc] init];
    [_line setLineWidth:8.0];
    
    // Set level to 0
    self.level = 0;
}

#pragma mark - UIView Methods

// Draws paths
- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] setStroke];
    [_line stroke];
}

// Sets the center point
- (void)setCenterPoint:(CGPoint)centerPoint
{
    _centerCircle.center = centerPoint;
    [_line removeAllPoints];
    [_line moveToPoint:centerPoint];
    
    _indicator.hidden = YES;
    _centerCircle.hidden = NO;
    self.level = 0;
    
    [self setNeedsDisplay];
}

// User dragged finger
- (void)userDraggedTo:(CGPoint)fingerPoint
{
    [_line removeAllPoints];
    [_line moveToPoint:_centerCircle.center];
    [_line addLineToPoint:fingerPoint];
    
    _indicator.center = CGPointMake(fingerPoint.x, fingerPoint.y - 40.0);
    _indicator.hidden = NO;
    
    if (fingerPoint.x < _centerCircle.center.x - 30.0 && fingerPoint.x > _centerCircle.center.x - 130.0) {
        _indicator.image = _frframeImage;
        self.level = -1;
    } else if (fingerPoint.x < _centerCircle.center.x - 130.0 && fingerPoint.x > _centerCircle.center.x - 230.0) {
        _indicator.image = _frImage;
        self.level = -2;
    } else if (fingerPoint.x < _centerCircle.center.x - 230.0 && fingerPoint.x > _centerCircle.center.x - 330.0) {
        _indicator.image = _frrImage;
        self.level = -3;
    } else if (fingerPoint.x < _centerCircle.center.x - 330.0) {
        _indicator.image = _frrrImage;
        self.level = -4;
    } else if (fingerPoint.x > _centerCircle.center.x + 30.0 && fingerPoint.x < _centerCircle.center.x + 130.0) {
        _indicator.image = _fframeImage;
        self.level = 1;
    } else if (fingerPoint.x > _centerCircle.center.x + 130.0 && fingerPoint.x < _centerCircle.center.x + 230.0) {
        _indicator.image = _ffImage;
        self.level = 2;
    } else if (fingerPoint.x > _centerCircle.center.x + 230.0 && fingerPoint.x < _centerCircle.center.x + 330.0) {
        _indicator.image = _fffImage;
        self.level = 3;
    } else if (fingerPoint.x > _centerCircle.center.x + 330.0) {
        _indicator.image = _ffffImage;
        self.level = 4;
    } else {
        _indicator.hidden = YES;
        self.level = 0;
    }
    
    [self setNeedsDisplay];
}

@end
