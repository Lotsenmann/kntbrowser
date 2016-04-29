//
//  BrowserViewController.h
//  SKBrowser
//
//  Created by Marco A. Hudelist on 16.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import "AssetLoader.h"
#import "FrameButton.h"
#import "GestureFFFRView.h"
#import "Video.h"

#import "AssetLoaderDelegate.h"
#import "RootDelegate.h"

@interface BrowserViewController : UIViewController
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property id<RootDelegate> delegate;

@property AssetLoader *assetLoader;
@property Video *video;
@property BOOL demoMode;

@property (weak, nonatomic) IBOutlet UICollectionView *lvl1ColView;
@property (weak, nonatomic) IBOutlet UICollectionView *lvl2ColView;
@property (weak, nonatomic) IBOutlet UICollectionView *lvl3ColView;
@property (weak, nonatomic) IBOutlet UIView *videoPlayerView;
@property (weak, nonatomic) IBOutlet UISlider *timelineSlider;
@property (weak, nonatomic) IBOutlet UIButton *nextVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *prevVideoButton;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet GestureFFFRView *gestureControl;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
