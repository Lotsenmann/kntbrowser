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
