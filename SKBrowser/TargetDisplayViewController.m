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

#import "TargetDisplayViewController.h"

@interface TargetDisplayViewController ()
{
    Target *_target;
    NSTimer *_stopTimer;
    CGFloat _videoFPS;
    
    AVPlayer *_videoPlayer;
    AVPlayerItem *_videoPlayerItem;
    AVPlayerLayer *_videoPlayerLayer;
}

@end

@implementation TargetDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    if (_videoPlayerLayer != nil) {
        [_videoPlayerLayer removeFromSuperlayer];
    }
    _videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    
    CGRect videoViewFrame = CGRectMake(0, 0, self.playerView.frame.size.width, self.playerView.frame.size.height);
    
    _videoPlayerLayer.frame = videoViewFrame;
    
    [self.playerView.layer addSublayer:_videoPlayerLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_videoPlayer play];
    _stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(stopUpdate) userInfo:nil repeats:YES];
    self.blender.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stopUpdate
{
    if (CMTimeGetSeconds(_videoPlayer.currentTime) >= _target.endFrame / _videoFPS) {
        [_videoPlayer pause];
        [_stopTimer invalidate];
        _stopTimer = nil;
    }
}

- (void)setTarget:(Target *)target
{
    _target = target;
    Video *video = [_assetLoader getVideoOfName:target.videoName];
    
    self.blender.hidden = NO;
    AVAsset *avAsset = video.videoAsset;
    
    _videoPlayerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    
    if (_videoPlayer != nil) {
        [_videoPlayer replaceCurrentItemWithPlayerItem:_videoPlayerItem];
    } else {
        _videoPlayer = [[AVPlayer alloc] initWithPlayerItem:_videoPlayerItem];
    }
    
    _videoFPS = [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:avAsset];
    [_videoPlayer seekToTime:CMTimeMakeWithSeconds(_target.startFrame / _videoFPS, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (IBAction)startSearch:(UIButton *)sender
{
    [_videoPlayer pause];
    
    if (_stopTimer != nil) {
        [_stopTimer invalidate];
        _stopTimer = nil;
    }
    
    [self.delegate dismissTargetDisplayController];
}

- (float)getFrameRateFromAVPlayer:(AVPlayer *)player AVAsset:(AVAsset *)asset
{
    float fps = 0.00;
    if (player.currentItem.asset) {
        AVAssetTrack * videoATrack = [[asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
        if(videoATrack)
        {
            fps = videoATrack.nominalFrameRate;
        }
    }
    return fps;
}

@end
