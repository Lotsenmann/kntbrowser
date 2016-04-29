//
//  TargetDisplayViewController.h
//  CvCStudy
//
//  Created by Marco A. Hudelist on 17.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

#import "AssetLoader.h"
#import "Target.h"

#import "RootDelegate.h"

@interface TargetDisplayViewController : UIViewController

@property id<RootDelegate> delegate;

@property AssetLoader *assetLoader;

@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) IBOutlet UIImageView *blender;

- (void)setTarget:(Target *)target;

@end
