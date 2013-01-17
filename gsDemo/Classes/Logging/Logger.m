//
//  Logger.m
//  MCHP MFI
//
//  Created by Andrew Aarestad on 1/14/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import "Logger.h"

@implementation Logger

static NSFileManager *fileManager;

static NSString *logsPath;
static NSString *currentDataFile;



// ================================================
// PUBLIC METHODS
// ================================================


// Write a string to logfile
// If no log is currently set, create one.
+(void)log:(NSString*)message
{
    if (!fileManager)
    {
        [self initFileManager];
        [self ensureLogsPathExists];
    }
    
    if (!currentDataFile)
    {
        currentDataFile = [self getNewDataFileName];
        [fileManager createFileAtPath:currentDataFile contents:nil attributes:nil];
    }
    
    NSString *outputString = [NSString stringWithFormat:@"%@: %@\n",[[NSDate date] description],message];
    
    NSLog(@"file: %@",currentDataFile);
    NSFileHandle *output = [NSFileHandle fileHandleForUpdatingAtPath:currentDataFile];
    [output seekToEndOfFile];
    [output writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [output closeFile];
    
}


// ================================================
// PRIVATE METHODS
// ================================================


+(void)initFileManager
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    fileManager = [[NSFileManager alloc] init];
    logsPath = [docsDir stringByAppendingPathComponent:@"groundStation"];
    
}

+(void)ensureLogsPathExists
{
    if (![fileManager fileExistsAtPath:logsPath isDirectory:nil])
    {
        NSError *error;
        
        if (![fileManager createDirectoryAtPath:logsPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            //[self showError:[error localizedDescription]];
        }

    }
}


+(NSString*)getNewDataFileName {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy_MM_dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH_mm_ss"];
    
    NSDate *now = [NSDate date];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    NSString *fileStr = [NSString stringWithFormat:@"%@_%@.txt", theDate,theTime];
    
    return [logsPath stringByAppendingPathComponent:fileStr];
}


/*
-(NSOutputStream *) openDataStream
{
    [self createDataFile];
    //NSString *path = [self.dataDir stringByAppendingPathComponent:filename];
    NSOutputStream *os = [[NSOutputStream alloc] initToFileAtPath:self.dataDir append:NO];
    [os open];
    
    return os;
}

-(NSString*)stopLog
{
    NSLog(@"Stopping log...");
    [self.dataFile close];
    NSString *newFilePath = self.dataDir;
    self.dataDir = nil;
    self.dataFile = nil;
    return newFilePath;
}

-(void)writeHeader:(NSOutputStream*)fileHandle
{
    NSString *str = @"TimeStamp,Lattitude,Longitude,Altitude,HorizontalAccuracy,VerticalAccuracy,Speed,Course,AccelX,AccelY,AccelZ,GyroX,GyroY,GyroZ\n";
    //NSLog(@"%@",str);
    
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.dataFile write:(uint8_t *)[strData bytes] maxLength:[strData length]];
    
    str = @"time,degrees,degrees,meters,meters,meters,mps,degrees,G's (9.8m/s^2),G's (9.8m/s^2),G's (9.8m/s^2),radians/s,radians/s,radians/s\n";
    strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.dataFile write:(uint8_t *)[strData bytes] maxLength:[strData length]];
    
    
    
}*/


@end
