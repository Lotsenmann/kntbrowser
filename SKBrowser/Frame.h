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
