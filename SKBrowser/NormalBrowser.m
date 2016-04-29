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

#import "NormalBrowser.h"

@interface NormalBrowser ()
{
    Video *_video;
    MPMoviePlayerController *player;
    BOOL _demoMode;
    NSTimer *_timeUpdater;
    NSDate *_startTime;
}

@end

@implementation NormalBrowser

- (id)init
{
    if (self = [super init]) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    
}

- (BOOL)demoMode
{
    return _demoMode;
}

- (void)setDemoMode:(BOOL)demoMode
{
    _demoMode = demoMode;
    
    if (demoMode) {
        self.timeLabel.hidden = YES;
        self.backButton.hidden = NO;
        self.submitButton.hidden = YES;
    } else {
        self.timeLabel.hidden = NO;
        self.backButton.hidden = YES;
        self.submitButton.hidden = NO;
    }
}

- (IBAction)dismissDemo:(UIButton *)sender
{
    [self.delegate dismissDemo];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (player == nil) {
        player = [[MPMoviePlayerController alloc] initWithContentURL:_video.videoALAsset.defaultRepresentation.url];
    } else {
        [player setContentURL:_video.videoALAsset.defaultRepresentation.url];
    }
    
    player.controlStyle = MPMovieControlStyleEmbedded;
    
    [player prepareToPlay];
    
    if (!_demoMode) {
        self.timeLabel.text = @"00:00";
        _startTime = [NSDate date];
        _timeUpdater = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.timeLabel.text = @"00:00";
    [_timeUpdater invalidate];
    [player pause];
}

- (void)updateTime
{
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate:_startTime];
    NSUInteger minutes = interval / 60.0;
    NSUInteger seconds = interval - minutes * 60.0;
    
    NSString *string = [NSString stringWithFormat:@"%d:%d", (int)minutes, (int)seconds];
    self.timeLabel.text = string;
}

- (Video *)video
{
    return _video;
}

- (void)setVideo:(Video *)video
{
    _video = video;
}

- (void)viewDidLoad
{
    
}

- (void)viewDidLayoutSubviews
{
    [player.view setFrame:self.playerView.bounds];
    [self.playerView addSubview:player.view];
    
    if (_demoMode) {
        self.timeLabel.hidden = YES;
        self.backButton.hidden = NO;
        self.submitButton.hidden = YES;
    } else {
        self.timeLabel.hidden = NO;
        self.backButton.hidden = YES;
        self.submitButton.hidden = NO;
    }
}


- (IBAction)submitFrame:(UIButton *)sender
{
    CGFloat framenumber = player.currentPlaybackTime * 25.0;
    
    [player pause];
    
    [self.delegate dismissNormalBrowserWithFrameNr:framenumber];
}

@end
