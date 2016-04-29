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

#define OVERWRITE_LOGFILE NO


#import "SimpleLogger.h"

@interface SimpleLogger ()
{
    NSString *_logFileName;
    NSString *_logFilePath;
    NSString *_documentsFolderPath;
    NSString *_header;
}

@end

@implementation SimpleLogger

- (id)init
{
    if (self = [super init]) {
        // Determine required file paths
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
        
        _documentsFolderPath = [paths objectAtIndex:0];
        
        // Setup filepath to new log-file
        _logFileName = [[NSString alloc] initWithFormat:@"log.csv"];
        _logFilePath = [_documentsFolderPath stringByAppendingPathComponent:_logFileName];
    }
    
    return self;
}

- (NSString *)filename
{
    return _logFileName;
}

- (void)setFilename:(NSString *)filename
{
    _logFileName = [filename stringByAppendingString:@".csv"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"_yyyyMMdd_HHmmss"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    _logFileName = [_logFileName stringByAppendingString:stringFromDate];
    
    _logFilePath = [_documentsFolderPath stringByAppendingPathComponent:_logFileName];
    
}

- (void)setHeader:(NSString *)header
{
    _header = header;
    _header = [_header stringByAppendingString:@"\n"];
}

- (void)appendToCurLogfile:(NSString *)logMessage
{
    // Append time stamp
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    logMessage = [NSString stringWithFormat:@"%f;%@\n", timeStamp, logMessage];
    
    // Handle for log file
    NSFileHandle * handle;

    // Check if log file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:_logFilePath] || OVERWRITE_LOGFILE)
    {
        // Log file does not exist - create it
        [[NSFileManager defaultManager] createFileAtPath:_logFilePath
                                                contents:nil
                                              attributes:nil];
        
        // Set file handle
        handle = [NSFileHandle fileHandleForWritingAtPath:_logFilePath];
        
        // Move to bottom of file
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        
        // Write header
        [handle writeData:[_header dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Write log message
        [handle writeData:[logMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Close log file
        [handle closeFile];
    }
    else
    {
        // Set file handle
        handle = [NSFileHandle fileHandleForWritingAtPath:_logFilePath];
        
        // Move to bottom of the file
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        
        // Write log message
        [handle writeData:[logMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Close log file
        [handle closeFile];
    }
}

@end
