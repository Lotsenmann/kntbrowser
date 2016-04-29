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
