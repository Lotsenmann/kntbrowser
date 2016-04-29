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

#import "TargetManager.h"

@interface TargetManager ()
{
    NSMutableArray *_targetSets;
    Target *_currentParsingTarget;
    NSMutableArray *_currentTargetSet;
    NSArray *_targetSetOrder;
    
    NSUInteger _targetSetIndex;
    NSUInteger _targetSetOrderIndex;
    NSUInteger _targetIndex;
    
    NSXMLParser *_xmlParser;
}

@end

@implementation TargetManager

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        _targetSets = [[NSMutableArray alloc] init];
        _targetSetIndex = _targetIndex = 0;
    }
    return self;
}

#pragma mark - Private Methods



#pragma mark - Public Methods

// Loads the target file(s)
- (BOOL)loadTargets
{
    BOOL loadingStatus = NO;
    
    //Creating Path
    NSString *path = [[NSBundle mainBundle] pathForResource:PARSER_FILENAME ofType:@"xml"];
    
    // Load contents of file
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // Init parser
    _xmlParser = [[NSXMLParser alloc] initWithData:data];
    _xmlParser.delegate = self;
    
    // Start parser
    loadingStatus = [_xmlParser parse];
    
    return loadingStatus;
}

// Sets the devision from which targets are drawn. Resets the current index!
- (void)setTargetSetOrder:(NSArray *)order
{
    _targetSetOrder = order;
    
    // Set initial targetset
    NSUInteger targetSetIndex = [_targetSetOrder[0] intValue];
    
    _currentTargetSet = _targetSets[targetSetIndex];
    _targetIndex = 0;
    _targetSetOrderIndex = 1;
}

// Returns the next target on the list
- (Target *)getNextTarget
{
    Target *nextTarget = nil;
    
    if (_targetIndex < _currentTargetSet.count) {
        // Still more targets available in current targetset
        nextTarget = _currentTargetSet[_targetIndex];
        _targetIndex++;
    } else if (_targetSetOrderIndex < _targetSetOrder.count) {
        // Still more target sets available
        NSUInteger targetSetIndex = [_targetSetOrder[_targetSetOrderIndex] intValue];
        _targetSetOrderIndex++;
        _currentTargetSet = _targetSets[targetSetIndex];
        _targetIndex = 0;
        nextTarget = _currentTargetSet[_targetIndex];
        _targetIndex++;
    }
    
    return nextTarget;
}

#pragma mark - NSXMLParser Delegate Methods

// Start of element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:PARSER_TARGET_SET_COLLECTION]) {
        // Entry into file
    } else if ([elementName isEqualToString:PARSER_TARGET_SET]) {
        // New target set
        _currentTargetSet = [[NSMutableArray alloc] init];
        [_targetSets addObject:_currentTargetSet];
    } else if ([elementName isEqualToString:PARSER_TARGET]) {
        // New target
        _currentParsingTarget = [[Target alloc] init];
        _currentParsingTarget.videoName = [attributeDict valueForKey:PARSER_TARGET_ATTRIB_VIDEO];
        _currentParsingTarget.startFrame = [[attributeDict valueForKey:PARSER_TARGET_ATTRIB_STARTFRAME] intValue];
        _currentParsingTarget.endFrame = [[attributeDict valueForKey:PARSER_TARGET_ATTRIB_ENDFRAME] intValue];
        _currentParsingTarget.targetSetIndex = _targetSets.count - 1;
        [_currentTargetSet addObject:_currentParsingTarget];
    }
}

@end
