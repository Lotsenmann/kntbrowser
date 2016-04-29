//
//  AssetLoader.h
//  CvCStudy
//
//  Created by Marco A. Hudelist on 09.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <ImageIO/CGImageProperties.h>

#import "Frame.h"
#import "Video.h"

#import "AssetLoaderDelegate.h"

@interface AssetLoader : NSObject

@property id<AssetLoaderDelegate> delegate;
@property (readonly) Video *nextVideo;
@property (readonly) Video *prevVideo;
@property (readonly) BOOL moreNextVideos;
@property (readonly) BOOL morePrevVideos;

- (id)init;
- (void)loadAssets;
- (Video *)getVideoOfName:(NSString *)videoName;

@end
