//
//  Frame.h
//  SKBrowser
//
//  Created by Marco A. Hudelist on 17.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>

@interface Frame : NSObject

@property (readonly) UIImage *thumbnail;
@property (readonly) UIImage *aspectRatioThumbnail;
@property (readonly) UIImage *fullImage;
@property ALAsset *asset;
@property NSInteger index;
@property NSInteger framenumber;
@property int subShotStartFrame;
@property int subShotEndFrame;
@property int stripNumber;

- (id)initWithAsset:(ALAsset *)asset colorIndex:(NSInteger)index;
- (id)initWithAsset:(ALAsset *)asset;

@end
