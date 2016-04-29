//
//  Frame.m
//  SKBrowser
//
//  Created by Marco A. Hudelist on 17.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "Frame.h"

@interface Frame ()
{
    UIImage *_thumbnail;
    UIImage *_aspectRatioThumbnail;
}
@end

@implementation Frame

#pragma mark - Initialization

- (id)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (id)initWithAsset:(ALAsset *)asset colorIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.asset = asset;
        self.index = index;
    }
    return self;
}

#pragma mark - Custom Properties

- (UIImage *)thumbnail
{
    if (_thumbnail == nil) {
        _thumbnail = [UIImage imageWithCGImage:self.asset.thumbnail];
    }
    
    return _thumbnail;
}

- (UIImage *)aspectRatioThumbnail
{
    if (_aspectRatioThumbnail == nil) {
        _aspectRatioThumbnail = [UIImage imageWithCGImage:self.asset.aspectRatioThumbnail];
    }
    
    return _aspectRatioThumbnail;
}

- (UIImage *)fullImage
{
    return [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullResolutionImage];
}

@end
