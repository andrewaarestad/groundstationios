//
//  Logger.m
//  MCHP MFI
//
//  Created by Andrew Aarestad on 1/14/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import "Logger.h"
#import "MCHP_MFIAppDelegate.h"
#import "MCHP_MFIViewController.h"


@implementation Logger

static Logger *sharedLogger;



// ================================================
// PUBLIC METHODS
// ================================================


// Write a string to logfile
// If no log is currently set, create one.
+(void)logDebug:(NSString*)message
{
    if (!sharedLogger)
    {
        [self initLogger];
    }
    
    if (!sharedLogger.currentDataFile)
    {
        [sharedLogger setupNewDataFile];
    }
    if (!sharedLogger.currentLogFile)
    {
        [sharedLogger setupNewLogFile];
    }
    
    NSString *outputString = [NSString stringWithFormat:@"%@: %@\n",[[NSDate date] description],message];
    
    NSLog(@"wrote to debug file: %@ size: %@",sharedLogger.currentLogFile,[[sharedLogger.fileManager attributesOfItemAtPath:sharedLogger.currentLogFile error:nil] valueForKey:@"NSFileSize"]);
    NSFileHandle *output = [NSFileHandle fileHandleForUpdatingAtPath:sharedLogger.currentLogFile];
    [output seekToEndOfFile];
    [output writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [output closeFile];
    
    
    
}

+(void)logData:(NSData*)data
{
    if (!sharedLogger)
    {
        [self initLogger];
    }
    
    if (!sharedLogger.currentDataFile)
    {
        [sharedLogger setupNewLogFile];
    }
    
    NSLog(@"wrote to data file: %@ size: %@",sharedLogger.currentDataFile,[[sharedLogger.fileManager attributesOfItemAtPath:sharedLogger.currentDataFile error:nil] valueForKey:@"NSFileSize"]);
    NSFileHandle *output = [NSFileHandle fileHandleForUpdatingAtPath:sharedLogger.currentDataFile];
    [output seekToEndOfFile];
    [output writeData:data];
    
    [output closeFile];
    
    [self updateDisplay];
    
}

+(void)userPressedNewLogButton
{
    // Upload log to Dropbox
    [[sharedLogger dbClient] uploadFile:[sharedLogger.currentDataFile lastPathComponent] toPath:@"/" withParentRev:nil fromPath:sharedLogger.currentDataFile];
    
    [sharedLogger setupNewDataFile];
    
    [Logger logDebug:[NSString stringWithFormat:@"Started new log at: %@",[[NSDate date] description]]];
    
    [self updateDisplay];
}


// ================================================
// PRIVATE METHODS
// ================================================

+(void)initLogger
{
    sharedLogger = [[Logger alloc] init];
    [sharedLogger initFileManager];
    [sharedLogger ensureLogsPathExists];
}

+(void)updateDisplay
{
    // Set file name
    sharedLogger.currentDisplayUpdateFileName = [sharedLogger.currentDataFile lastPathComponent];
    
    
    
    // Set file size
    NSNumber *fileSize = [[sharedLogger.fileManager attributesOfItemAtPath:sharedLogger.currentDataFile error:nil] valueForKey:@"NSFileSize"];
    sharedLogger.currentDisplayUpdateFileSize = [fileSize doubleValue];
    NSString *fileSizeString = [self stringFromFileSize:sharedLogger.currentDisplayUpdateFileSize];
    if ([fileSizeString isEqualToString:@""])
        { fileSizeString = @"0"; }
    
    
    // Determine and set bytes per sec
    // Don't update display if the log file has changed to a new name
    if (sharedLogger.lastDisplayUpdateTime && [sharedLogger.currentDisplayUpdateFileName isEqualToString:sharedLogger.lastDisplayUpdateFileName])
    {
        double timeSinceLastUpdate = [[NSDate date] timeIntervalSinceDate:sharedLogger.lastDisplayUpdateTime];
        
        double bytesSinceLastUpdate = sharedLogger.currentDisplayUpdateFileSize - sharedLogger.lastDisplayUpdateFileSize;
        
        double bytesPerSec = 0;
        if (timeSinceLastUpdate > 0)
        {
            bytesPerSec = bytesSinceLastUpdate / timeSinceLastUpdate;
        }
        NSLog(@"bps: %f",bytesPerSec);
        sharedLogger.currentBytesPerSec = [NSString stringWithFormat:@"%.02f",bytesPerSec];
        
    }
    else
    {
        sharedLogger.currentBytesPerSec = @"n/a";
    }
    
    
    // Update display
    [[[MCHP_MFIAppDelegate sharedDelegate] viewController]setNewLogFileName:sharedLogger.currentDisplayUpdateFileName];
    [[[MCHP_MFIAppDelegate sharedDelegate] viewController]setNewLogFileSize:fileSizeString];
    sharedLogger.currentDisplayUpdateTime = [NSDate date];
    [[[MCHP_MFIAppDelegate sharedDelegate] viewController]setNewLogBytesPerSec:sharedLogger.currentBytesPerSec];
    
    // Save display status
    sharedLogger.lastDisplayUpdateFileName = sharedLogger.currentDisplayUpdateFileName;
    sharedLogger.lastDisplayUpdateFileSize = sharedLogger.currentDisplayUpdateFileSize;
    sharedLogger.lastDisplayUpdateTime = sharedLogger.currentDisplayUpdateTime;
}

-(void)initFileManager
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    self.fileManager = [[NSFileManager alloc] init];
    self.logsPath = [docsDir stringByAppendingPathComponent:@"groundStation"];
    
}

-(void)ensureLogsPathExists
{
    if (![self.fileManager fileExistsAtPath:self.logsPath isDirectory:nil])
    {
        NSError *error;
        
        if (![self.fileManager createDirectoryAtPath:self.logsPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            //[self showError:[error localizedDescription]];
        }

    }
}


-(void)setupNewLogFile

{
    sharedLogger.currentLogFile = [sharedLogger getNewLogFileName];
    [sharedLogger.fileManager createFileAtPath:sharedLogger.currentLogFile contents:nil attributes:nil];
}

-(void)setupNewDataFile

{
    sharedLogger.currentDataFile = [sharedLogger getNewDataFileName];
    [sharedLogger.fileManager createFileAtPath:sharedLogger.currentDataFile contents:nil attributes:nil];
}

-(NSString*)getNewDataFileName {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy_MM_dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH_mm_ss"];
    
    NSDate *now = [NSDate date];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    NSString *fileStr = [NSString stringWithFormat:@"debug_%@_%@.txt", theDate,theTime];
    
    return [self.logsPath stringByAppendingPathComponent:fileStr];
}

-(NSString*)getNewLogFileName {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy_MM_dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH_mm_ss"];
    
    NSDate *now = [NSDate date];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    NSString *fileStr = [NSString stringWithFormat:@"data_%@_%@.txt", theDate,theTime];
    
    return [self.logsPath stringByAppendingPathComponent:fileStr];
}

- (DBRestClient*)dbClient
{
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}


// Helpers
+(NSString *)stringFromFileSize:(NSInteger) theSize
{
    /*
     From http://snippets.dzone.com/posts/show/3038 with slight modification
     */
    float floatSize = theSize;
    if (theSize<1023)
        return([NSString stringWithFormat:@"%i bytes",theSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1024;
    
    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
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
