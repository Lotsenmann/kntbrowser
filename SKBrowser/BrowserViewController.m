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

#import "BrowserViewController.h"

@interface BrowserViewController ()
{
    AssetLoader *_assetLoader;
    
    AVPlayer *_videoPlayer;
    AVPlayerItem *_videoPlayerItem;
    AVPlayerLayer *_videoPlayerLayer;
    CGFloat _videoFPS;
    
    CGFloat _rateBeforeLongPress;
    NSInteger _currentLevel;
    
    NSTimer *_playingUpdater;
    NSTimer *_fastForwarder;
    NSTimer *_fastForwarder2;
    
    Video *_currentVideo;
    
    UILongPressGestureRecognizer *_videoLongPressRegoc;
    
    NSTimer *_timeUpdater;
    NSDate *_startTime;
    
    UIScrollView *_lastScrollViewDragged;
    
    
    BOOL _sliderManipulationOngoing;
    BOOL _demoMode;
}

@end

@implementation BrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_currentVideo == nil) {
        _currentVideo = _assetLoader.nextVideo;
    }

    [self initializeNewVideo];
    
    if (!_demoMode) {
        self.timeLabel.text = @"00:00";
        _startTime = [NSDate date];
        _timeUpdater = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
}

- (void)viewDidLayoutSubviews
{
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

- (void)viewDidDisappear:(BOOL)animated
{
    self.timeLabel.text = @"00:00";
    [_timeUpdater invalidate];
    [_videoPlayer pause];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVideo:(Video *)video
{
    _currentVideo = video;
}

- (Video *)video
{
    return _currentVideo;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"framecell" forIndexPath:indexPath];
    
    Frame *frame = _currentVideo.videoFrames[indexPath.row];
    FrameButton *frameButton = (FrameButton *)[cell viewWithTag:1];
    [frameButton setImage:frame.aspectRatioThumbnail forState:UIControlStateNormal];
    frameButton.videoFrame = frame;
    frameButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _currentVideo.videoFrames.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastScrollViewDragged = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _lastScrollViewDragged) {
        CGPoint dummyOffset = scrollView.contentOffset;
        dummyOffset.x += 0.1;
        [scrollView setContentOffset:dummyOffset animated:NO];
        dummyOffset.x -= 0.1;
        [scrollView setContentOffset:dummyOffset animated:NO];
        return;
    }
    
    
    if (!scrollView.dragging || _sliderManipulationOngoing) {
        return;
    }

    [_videoPlayer pause];
    [_playingUpdater invalidate];
    _playingUpdater = nil;
    
    if (scrollView == self.lvl1ColView) {
        
        
        // Changing the value of the slider apropriatly
        // Get frame that is currently under the red line
        NSUInteger frameindex = MIN(self.lvl1ColView.contentOffset.x / 25.0, _currentVideo.videoFrames.count - 1);
        
        Frame *frame = _currentVideo.videoFrames[frameindex];
        int startFrame = frame.subShotStartFrame;
        int endFrame = frame.subShotEndFrame;
        int duration = endFrame - startFrame;
        
        CGFloat cx = MAX(self.lvl1ColView.contentOffset.x - frameindex * 25.0, 0);
        CGFloat cellpercent = cx / 25.0;
        CGFloat cellframes = duration * cellpercent;
        NSUInteger currentFrame = startFrame + cellframes;
        CGFloat videoFrames = CMTimeGetSeconds(_videoPlayerItem.duration) * [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:_videoPlayerItem.asset];
        self.timelineSlider.value = currentFrame / videoFrames;
        
        // Position video player
        CMTime timecode = CMTimeMakeWithSeconds(CMTimeGetSeconds(_videoPlayerItem.duration) * self.timelineSlider.value, NSEC_PER_SEC);
        [_videoPlayer seekToTime:timecode toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
        
        // Level 2
        CGFloat contentOffsetStartFrame = 60.0 * frameindex;
        NSUInteger frameDelta = currentFrame - frame.subShotStartFrame;
        NSUInteger frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
        CGFloat framePercent = (float)frameDelta / (float)frameDuration;
        CGFloat contentOffsetInnerFrame = 60.0 * framePercent;
        CGFloat contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
        self.lvl2ColView.contentOffset = CGPointMake(contentOffset, self.lvl2ColView.contentOffset.y);
        
        
        // Level 3
        contentOffsetStartFrame = 200.0 * frameindex;
        frameDelta = currentFrame - frame.subShotStartFrame;
        frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
        framePercent = (float)frameDelta / (float)frameDuration;
        contentOffsetInnerFrame = 200.0 * framePercent;
        contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
        self.lvl3ColView.contentOffset = CGPointMake(contentOffset, self.lvl3ColView.contentOffset.y);
    } else if (scrollView == self.lvl2ColView) {
        
        // Changing the value of the slider apropriatly
        // Get frame that is currently under the red line
        NSUInteger frameindex = MIN(self.lvl2ColView.contentOffset.x / 60.0, _currentVideo.videoFrames.count - 1);
        
        Frame *frame = _currentVideo.videoFrames[frameindex];
        int startFrame = frame.subShotStartFrame;
        int endFrame = frame.subShotEndFrame;
        int duration = endFrame - startFrame;
        
        CGFloat cx = MAX(self.lvl2ColView.contentOffset.x - frameindex * 60.0, 0);
        CGFloat cellpercent = cx / 60.0;
        CGFloat cellframes = duration * cellpercent;
        NSUInteger currentFrame = startFrame + cellframes;
        CGFloat videoFrames = CMTimeGetSeconds(_videoPlayerItem.duration) * [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:_videoPlayerItem.asset];
        self.timelineSlider.value = currentFrame / videoFrames;
        
        // Position video player
        CMTime timecode = CMTimeMakeWithSeconds(CMTimeGetSeconds(_videoPlayerItem.duration) * self.timelineSlider.value, NSEC_PER_SEC);
        [_videoPlayer seekToTime:timecode toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
        // Level 1
        CGFloat contentOffsetStartFrame = 25.0 * frameindex;
        NSUInteger frameDelta = currentFrame - frame.subShotStartFrame;
        NSUInteger frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
        CGFloat framePercent = (float)frameDelta / (float)frameDuration;
        CGFloat contentOffsetInnerFrame = 25.0 * framePercent;
        CGFloat contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
        self.lvl1ColView.contentOffset = CGPointMake(contentOffset, self.lvl1ColView.contentOffset.y);
        
        // Level 3
        contentOffsetStartFrame = 200.0 * frameindex;
        frameDelta = currentFrame - frame.subShotStartFrame;
        frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
        framePercent = (float)frameDelta / (float)frameDuration;
        contentOffsetInnerFrame = 200.0 * framePercent;
        contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
        self.lvl3ColView.contentOffset = CGPointMake(contentOffset, self.lvl3ColView.contentOffset.y);
    } else {

        // Changing the value of the slider apropriatly
        // Get frame that is currently under the red line
        NSUInteger frameindex = MIN(self.lvl3ColView.contentOffset.x / 200.0, _currentVideo.videoFrames.count - 1);
        
        Frame *frame = _currentVideo.videoFrames[frameindex];
        int startFrame = frame.subShotStartFrame;
        int endFrame = frame.subShotEndFrame;
        int duration = endFrame - startFrame;
        
        CGFloat cx = MAX(self.lvl3ColView.contentOffset.x - frameindex * 200.0, 0);
        CGFloat cellpercent = cx / 200.0;
        CGFloat cellframes = duration * cellpercent;
        NSUInteger currentFrame = startFrame + cellframes;
        CGFloat videoFrames = CMTimeGetSeconds(_videoPlayerItem.duration) * [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:_videoPlayerItem.asset];
        self.timelineSlider.value = currentFrame / videoFrames;
        
        // Position video player
        CMTime timecode = CMTimeMakeWithSeconds(CMTimeGetSeconds(_videoPlayerItem.duration) * self.timelineSlider.value, NSEC_PER_SEC);
        [_videoPlayer seekToTime:timecode toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
        // Level 1
        CGFloat contentOffsetStartFrame = 25.0 * frameindex;
        NSUInteger frameDelta = currentFrame - frame.subShotStartFrame;
        NSUInteger frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
        CGFloat framePercent = (float)frameDelta / (float)frameDuration;
        CGFloat contentOffsetInnerFrame = 25.0 * framePercent;
        CGFloat contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
        self.lvl1ColView.contentOffset = CGPointMake(contentOffset, self.lvl1ColView.contentOffset.y);
        
        
        // Level 2
        contentOffsetStartFrame = 60.0 * frameindex;
        frameDelta = currentFrame - frame.subShotStartFrame;
        frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
        framePercent = (float)frameDelta / (float)frameDuration;
        contentOffsetInnerFrame = 60.0 * framePercent;
        contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
        self.lvl2ColView.contentOffset = CGPointMake(contentOffset, self.lvl2ColView.contentOffset.y);
    }
}

- (void)initializeNewVideo
{
    self.videoNameLabel.text = _currentVideo.videoName;
    
    [self.lvl1ColView reloadData];
    [self.lvl1ColView setContentOffset:CGPointZero];
    [self.lvl2ColView reloadData];
    [self.lvl2ColView setContentOffset:CGPointZero];
    [self.lvl3ColView reloadData];
    [self.lvl3ColView setContentOffset:CGPointZero];
    
    [self loadVideo];
    
    if (_assetLoader.moreNextVideos) {
        self.nextVideoButton.enabled = YES;
        self.nextVideoButton.alpha = 1.0;
    } else {
        self.nextVideoButton.enabled = NO;
        self.nextVideoButton.alpha = 0.5;
    }
    
    if (_assetLoader.morePrevVideos) {
        self.prevVideoButton.enabled = YES;
        self.prevVideoButton.alpha = 1.0;
    } else {
        self.prevVideoButton.enabled = NO;
        self.prevVideoButton.alpha = 0.5;
    }
    
    self.timelineSlider.value = 0.0;
    
    if (_playingUpdater != nil) {
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    }
    
    if (_fastForwarder != nil) {
        [_fastForwarder invalidate];
        _fastForwarder = nil;
    }
    
    _videoPlayer.rate = 0;
}

- (Frame *)getFrameForFramenumber:(NSUInteger)framenumber
{
    Frame *frame;
    
    for (int i = 0; i < _currentVideo.videoFrames.count; i++) {
        frame = _currentVideo.videoFrames[i];
        
        if (frame.subShotStartFrame <= framenumber && frame.subShotEndFrame >= framenumber) {
            break;
        }
    }
    
    return frame;
}

// Loads the first video from the asset manager and plays it.
- (void)loadVideo
{
    AVAsset *avAsset = _currentVideo.videoAsset;

    _videoPlayerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    
    _videoPlayer = [[AVPlayer alloc] initWithPlayerItem:_videoPlayerItem];
    
    if (_videoPlayerLayer != nil) {
        [_videoPlayerLayer removeFromSuperlayer];
    }
    _videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    
    CGRect videoViewFrame = CGRectMake(0, 0, self.videoPlayerView.frame.size.width, self.videoPlayerView.frame.size.height);
    
    _videoPlayerLayer.frame = videoViewFrame;
    
    [self.videoPlayerView.layer addSublayer:_videoPlayerLayer];
    
    _videoFPS = [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:avAsset];
}

-(float)getFrameRateFromAVPlayer:(AVPlayer *)player AVAsset:(AVAsset *)asset
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

- (void)applyPlayerPosition
{
    NSTimeInterval currentPos = CMTimeGetSeconds(_videoPlayer.currentTime);
    NSUInteger framenumber = currentPos * [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:_videoPlayerItem.asset] + 1;
    
    Frame *frame = [self getFrameForFramenumber:framenumber];
    NSUInteger frameindex = [_currentVideo.videoFrames indexOfObject:frame];
    
    
    // Level 1
    CGFloat contentOffsetStartFrame = 25.0 * frameindex;
    NSUInteger frameDelta = framenumber - frame.subShotStartFrame;
    NSUInteger frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
    CGFloat framePercent = (float)frameDelta / (float)frameDuration;
    CGFloat contentOffsetInnerFrame = 25.0 * framePercent;
    CGFloat contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
    self.lvl1ColView.contentOffset = CGPointMake(contentOffset, self.lvl1ColView.contentOffset.y);
    
    
    // Level 2
    contentOffsetStartFrame = 60.0 * frameindex;
    frameDelta = framenumber - frame.subShotStartFrame;
    frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
    framePercent = (float)frameDelta / (float)frameDuration;
    contentOffsetInnerFrame = 60.0 * framePercent;
    contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
    self.lvl2ColView.contentOffset = CGPointMake(contentOffset, self.lvl2ColView.contentOffset.y);
    
    
    // Level 3
    contentOffsetStartFrame = 200.0 * frameindex;
    frameDelta = framenumber - frame.subShotStartFrame;
    frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
    framePercent = (float)frameDelta / (float)frameDuration;
    contentOffsetInnerFrame = 200.0 * framePercent;
    contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
    self.lvl3ColView.contentOffset = CGPointMake(contentOffset, self.lvl3ColView.contentOffset.y);

    
    // Sliderupdate
    NSTimeInterval duration = CMTimeGetSeconds(_currentVideo.videoAsset.duration);
    CGFloat percentage = currentPos / duration;
    self.timelineSlider.value = percentage;
}

- (void)ffUpdate
{
    CMTime currentTime = _videoPlayer.currentTime;
    CMTime nextTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(6.0, NSEC_PER_SEC));
    
    if (CMTimeCompare(nextTime, _videoPlayerItem.duration) > 0) {
        nextTime = _videoPlayerItem.duration;
    }
    
    if (CMTimeCompare(nextTime, CMTimeMakeWithSeconds(0, NSEC_PER_SEC)) == -1) {
        nextTime = CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
    }
    
    [_videoPlayer seekToTime:nextTime];
    
}

- (void)frUpdate
{
    CMTime currentTime = _videoPlayer.currentTime;
    CMTime nextTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(5.0, NSEC_PER_SEC));
    
    if (CMTimeCompare(nextTime, _videoPlayerItem.duration) > 0) {
        nextTime = _videoPlayerItem.duration;
    }
    
    if (CMTimeCompare(nextTime, CMTimeMakeWithSeconds(0, NSEC_PER_SEC)) == -1) {
        nextTime = CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
    }
    
    [_videoPlayer seekToTime:nextTime];
}

#pragma mark - Action Handlers

- (IBAction)playPauseVideoPlayer:(UITapGestureRecognizer *)sender
{
    if (_playingUpdater != nil) {
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    }
    
    if (_videoPlayer.rate > 0.0) {
        [_videoPlayer pause];
        
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    } else {
        [_videoPlayer play];
        
        _playingUpdater = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(applyPlayerPosition) userInfo:nil repeats:YES];
    }
}

- (IBAction)playPauseVideoPlayerButtonPressed:(UIButton *)sender
{
    if (_playingUpdater != nil) {
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    }
    
    if (_videoPlayer.rate > 0.0) {
        [_videoPlayer pause];
        
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    } else {
        [_videoPlayer play];
        
        _playingUpdater = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(applyPlayerPosition) userInfo:nil repeats:YES];
    }
}

- (IBAction)frameButtonPressed:(FrameButton *)sender
{
    NSInteger framenumber = sender.videoFrame.framenumber;
    
    CMTime timecode = CMTimeMakeWithSeconds(framenumber / _videoFPS, NSEC_PER_SEC);

    NSUInteger frameIndex = [_currentVideo.videoFrames indexOfObject:sender.videoFrame];
    
    CGFloat newOffsetXLvl1 = frameIndex * 25 + 12.5;
    
    self.lvl1ColView.contentOffset = CGPointMake(newOffsetXLvl1, self.lvl1ColView.contentOffset.y);
    
    CGFloat newOffsetXLvl2 = frameIndex * 60 + 30;
    
    self.lvl2ColView.contentOffset = CGPointMake(newOffsetXLvl2, self.lvl1ColView.contentOffset.y);
    
    CGFloat newOffsetXLvl3 = frameIndex * 200 + 100;
    
    self.lvl3ColView.contentOffset = CGPointMake(newOffsetXLvl3, self.lvl1ColView.contentOffset.y);
    
    [_videoPlayer seekToTime:timecode toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (IBAction)valueOfTimelineSliderChanged:(UISlider *)sender
{
    CGFloat percentage = sender.value;
    
    CMTime timecode = CMTimeMakeWithSeconds(CMTimeGetSeconds(_videoPlayerItem.duration) * percentage, NSEC_PER_SEC);
    [_videoPlayer seekToTime:timecode toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    CGFloat videoFrames = CMTimeGetSeconds(_videoPlayerItem.duration) * [self getFrameRateFromAVPlayer:_videoPlayer AVAsset:_videoPlayerItem.asset];
    
    NSUInteger framenumber = videoFrames * percentage + 1;
    
    Frame *frame = [self getFrameForFramenumber:framenumber];
    
    NSUInteger frameindex = [_currentVideo.videoFrames indexOfObject:frame];
    
    // Level 1
    CGFloat contentOffsetStartFrame = 25.0 * frameindex;
    NSUInteger frameDelta = framenumber - frame.subShotStartFrame;
    NSUInteger frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
    CGFloat framePercent = (float)frameDelta / (float)frameDuration;
    CGFloat contentOffsetInnerFrame = 25.0 * framePercent;
    CGFloat contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
    self.lvl1ColView.contentOffset = CGPointMake(contentOffset, self.lvl1ColView.contentOffset.y);

    
    // Level 2
    contentOffsetStartFrame = 60.0 * frameindex;
    frameDelta = framenumber - frame.subShotStartFrame;
    frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
    framePercent = (float)frameDelta / (float)frameDuration;
    contentOffsetInnerFrame = 60.0 * framePercent;
    contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
    self.lvl2ColView.contentOffset = CGPointMake(contentOffset, self.lvl2ColView.contentOffset.y);
    
    
    // Level 3
    contentOffsetStartFrame = 200.0 * frameindex;
    frameDelta = framenumber - frame.subShotStartFrame;
    frameDuration = frame.subShotEndFrame - frame.subShotStartFrame;
    framePercent = (float)frameDelta / (float)frameDuration;
    contentOffsetInnerFrame = 200.0 * framePercent;
    contentOffset = contentOffsetStartFrame + contentOffsetInnerFrame;
    self.lvl3ColView.contentOffset = CGPointMake(contentOffset, self.lvl3ColView.contentOffset.y);
    
    
    [_videoPlayer pause];
    [_playingUpdater invalidate];
    _playingUpdater = nil;
}

- (IBAction)showNextVideo:(UIButton *)sender
{
    _currentVideo = _assetLoader.nextVideo;
    
    [self initializeNewVideo];
}

- (IBAction)showPrevVideo:(UIButton *)sender
{
    _currentVideo = _assetLoader.prevVideo;
    
    [self initializeNewVideo];
}

- (IBAction)ffButtonPressed:(UIButton *)sender
{
    _videoPlayer.rate = 2.0;
}

- (IBAction)ffButtonDown:(UIButton *)sender
{
    _fastForwarder2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ffUpdate) userInfo:nil repeats:YES];
    _rateBeforeLongPress = _videoPlayer.rate;
    _videoPlayer.rate = 0;
    
    if (_playingUpdater == nil) {
        _playingUpdater = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(applyPlayerPosition) userInfo:nil repeats:YES];
    }
}

- (IBAction)ffButtonUp:(UIButton *)sender
{
    [_fastForwarder2 invalidate];
    _fastForwarder2 = nil;
    _videoPlayer.rate = _rateBeforeLongPress;
    
    if (_videoPlayer.rate == 0) {
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    }
}

- (IBAction)frButtonDown:(UIButton *)sender
{
    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(frUpdate) userInfo:nil repeats:YES];
    _rateBeforeLongPress = _videoPlayer.rate;
    _videoPlayer.rate = 0;
    
    if (_playingUpdater == nil) {
        _playingUpdater = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(applyPlayerPosition) userInfo:nil repeats:YES];
    }
}

- (IBAction)frButtonUp:(UIButton *)sender
{
    [_fastForwarder invalidate];
    _fastForwarder = nil;
    _videoPlayer.rate = _rateBeforeLongPress;
    
    if (_videoPlayer.rate == 0) {
        [_playingUpdater invalidate];
        _playingUpdater = nil;
    }
}

- (IBAction)ffButtonLifted:(UIButton *)sender
{
    _videoPlayer.rate = 1.0;
}

- (IBAction)frButtonLifted:(UIButton *)sender
{
    _videoPlayer.rate = 1.0;
}

- (IBAction)frButtonPressed:(UIButton *)sender
{
    _videoPlayer.rate = -2.0;
}

- (IBAction)dismissDemo:(UIButton *)sender
{
    [self.delegate dismissDemo];
}

- (IBAction)submitFrame:(UIButton *)sender
{
    [_videoPlayer pause];
    CGFloat framenumber = CMTimeGetSeconds(_videoPlayer.currentTime) * _videoFPS;
    [self.delegate dismissSkBrowserControllerWithFrameNr:framenumber];
}

- (IBAction)longPressOnVideo:(UILongPressGestureRecognizer *)sender
{
    CGPoint touchCoords = [sender locationInView:self.gestureControl];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.gestureControl setCenterPoint:touchCoords];
        [UIView animateWithDuration:0.2 animations:^{
            self.gestureControl.alpha = 1.0;
        }];
        _rateBeforeLongPress = _videoPlayer.rate;
        _currentLevel = 0;
        
        _playingUpdater = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(applyPlayerPosition) userInfo:nil repeats:YES];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.gestureControl.alpha = 0.0;
        }];
        _videoPlayer.rate = _rateBeforeLongPress;
        [_playingUpdater invalidate];
        _playingUpdater = nil;
        [_fastForwarder invalidate];
        _fastForwarder = nil;
    } else {
        [self.gestureControl userDraggedTo:touchCoords];
        _videoPlayer.rate = 0.0;
        switch (self.gestureControl.level) {
            case 0:
                if (_fastForwarder != nil) {
                    [_fastForwarder invalidate];
                    _fastForwarder = nil;
                }
                _currentLevel = 0;
                break;
                
            case 1:
                if (_fastForwarder != nil) {
                    [_fastForwarder invalidate];
                    _fastForwarder = nil;
                }
                _videoPlayer.rate = 2.0;
                _currentLevel = 1;
                break;
                
            case 2:
                if (_currentLevel != 2) {
                    if (_fastForwarder != nil) {
                        [_fastForwarder invalidate];
                    }
                    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(ffUpdate) userInfo:nil repeats:YES];
                    _currentLevel = 2;
                }
                break;
                
            case 3:
                if (_currentLevel != 3) {
                    if (_fastForwarder != nil) {
                        [_fastForwarder invalidate];
                    }
                    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.125 target:self selector:@selector(ffUpdate) userInfo:nil repeats:YES];
                    _currentLevel = 3;
                }
                break;
                
            case 4:
                if (_currentLevel != 4) {
                    if (_fastForwarder != nil) {
                        [_fastForwarder invalidate];
                    }
                    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(ffUpdate) userInfo:nil repeats:YES];
                    _currentLevel = 4;
                }
                break;
                
            case -1:
                if (_fastForwarder != nil) {
                    [_fastForwarder invalidate];
                    _fastForwarder = nil;
                }
                _videoPlayer.rate = -2.0;
                _currentLevel = -1;
                break;
                
            case -2:
                if (_currentLevel != -2) {
                    if (_fastForwarder != nil) {
                        [_fastForwarder invalidate];
                    }
                    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(frUpdate) userInfo:nil repeats:YES];
                    _currentLevel = -2;
                }
                break;
                
            case -3:
                if (_currentLevel != -3) {
                    if (_fastForwarder != nil) {
                        [_fastForwarder invalidate];
                    }
                    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.125 target:self selector:@selector(frUpdate) userInfo:nil repeats:YES];
                    _currentLevel = -3;
                }
                break;
                
            case -4:
                if (_currentLevel != -4) {
                    if (_fastForwarder != nil) {
                        [_fastForwarder invalidate];
                    }
                    _fastForwarder = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(frUpdate) userInfo:nil repeats:YES];
                    _currentLevel = -4;
                }
                break;
        }
        
        
    }
}


- (IBAction)sliderTouchDown:(UISlider *)sender
{
    // disable/stop scrolls of scrollviews
    _sliderManipulationOngoing = YES;
    CGPoint dummyOffset = self.lvl1ColView.contentOffset;
    dummyOffset.x += 0.1;
    [self.lvl1ColView setContentOffset:dummyOffset animated:NO];
    dummyOffset.x -= 0.1;
    [self.lvl1ColView setContentOffset:dummyOffset animated:NO];
    
    dummyOffset = self.lvl2ColView.contentOffset;
    dummyOffset.x += 0.1;
    [self.lvl2ColView setContentOffset:dummyOffset animated:NO];
    dummyOffset.x -= 0.1;
    [self.lvl2ColView setContentOffset:dummyOffset animated:NO];
    
    dummyOffset = self.lvl3ColView.contentOffset;
    dummyOffset.x += 0.1;
    [self.lvl3ColView setContentOffset:dummyOffset animated:NO];
    dummyOffset.x -= 0.1;
    [self.lvl3ColView setContentOffset:dummyOffset animated:NO];
}

- (IBAction)sliderTouchUp:(UISlider *)sender
{
    // enable scrolling of scrollviews again
    _sliderManipulationOngoing = NO;
}


@end
