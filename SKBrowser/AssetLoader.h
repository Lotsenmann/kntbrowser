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
