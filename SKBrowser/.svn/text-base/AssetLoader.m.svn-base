//
//  AssetLoader.m
//  CvCStudy
//
//  Created by Marco A. Hudelist on 09.07.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "AssetLoader.h"

@interface AssetLoader ()
{
    ALAsset *_video;
    ALAssetsLibrary *_library;
    NSArray *_videoNames;
    NSInteger _currentIndex;
    NSMutableDictionary *_collection;
}

@end

@implementation AssetLoader

#pragma mark - Initialization

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
    _library = [[ALAssetsLibrary alloc] init];
    _collection = [[NSMutableDictionary alloc] init];
    _currentIndex = -1;
}

#pragma mark - Custom Properties

- (Video *)nextVideo
{
    if (_currentIndex + 1 < _videoNames.count) {
        _currentIndex++;
        NSString *nextVideoName = _videoNames[_currentIndex];
        Video *nextVideo = _collection[nextVideoName];
        return nextVideo;
    } else {
        return nil;
    }
}

- (Video *)prevVideo
{
    if (_currentIndex - 1 >= 0) {
        _currentIndex--;
        NSString *prevVideoName = _videoNames[_currentIndex];
        Video *prevVideo = _collection[prevVideoName];
        return prevVideo;
    } else {
        return nil;
    }
}

- (BOOL)moreNextVideos
{
    if (_currentIndex + 1 < _videoNames.count) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)morePrevVideos
{
    if (_currentIndex > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Methods

- (void)loadAssets
{
    NSMutableArray *unsortedVideoNames = [[NSMutableArray alloc] init];
    
    // Enumerator for concept images
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            
            if ([groupName hasPrefix:@"sk"]) {
                NSString *videoName = [groupName substringFromIndex:2];
                [unsortedVideoNames addObject:videoName];
                
                Video *newVideo = [[Video alloc] init];
                newVideo.videoName = videoName;
                newVideo.videoFrames = [[NSMutableArray alloc] init];
                
                [_collection setObject:newVideo forKey:videoName];
                
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result != nil && [result valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto) {
                        Frame *frame = [[Frame alloc] initWithAsset:result];
                        
                        NSDictionary *metadata = result.defaultRepresentation.metadata;
                        NSDictionary *tiffDictionary = [metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
                        NSString *desc = [tiffDictionary objectForKey:(NSString *)kCGImagePropertyTIFFImageDescription];
                        NSArray *descComponents = [desc componentsSeparatedByString:@";"];
                        frame.subShotStartFrame = [descComponents[0] intValue];
                        frame.subShotEndFrame = [descComponents[1] intValue];
                        frame.framenumber = [descComponents[2] intValue];
                        
                        [newVideo.videoFrames addObject:frame];
                    } else if (result != nil && [result valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
                        AVAsset *videoAsset = [AVAsset assetWithURL:result.defaultRepresentation.url];
                        newVideo.videoAsset = videoAsset;
                        newVideo.videoALAsset = result;
                    }
                }];
            }
        } else {
            // Finished loading videos.
            // Sort video names for loop access
            _videoNames = [unsortedVideoNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            
            // Sort frames of all videos
            for (NSString *videoName in _videoNames) {
                Video *video = _collection[videoName];
                
                [video.videoFrames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSInteger first = [(Frame *)obj1 framenumber];
                    NSInteger second = [(Frame *)obj2 framenumber];
                    
                    if (first < second) return NSOrderedAscending;
                    else if (first > second) return NSOrderedDescending;
                    else return NSOrderedSame;
                }];
            }
            
            // Notify delegate
            [self.delegate loadingFinished];
        }
    };
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock:assetGroupEnumerator
                          failureBlock:nil];
}

- (Video *)getVideoOfName:(NSString *)videoName
{
    Video *video = _collection[videoName];
    
    if (video == nil) {
        NSLog(@"Could not find video named %@", videoName);
    }
    
    return video;
}

- (float)getFrameRateFromAVPlayer:(AVPlayer *)player AVAsset:(AVAsset *)asset
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

@end
