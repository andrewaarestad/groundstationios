//
//  Logger.m
//  MCHP MFI
//
//  Created by Andrew Aarestad on 1/14/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import "Logger.h"

@implementation Logger

static Logger *sharedLogger;



// ================================================
// PUBLIC METHODS
// ================================================


// Write a string to logfile
// If no log is currently set, create one.
+(void)log:(NSString*)message
{
    if (!sharedLogger)
    {
        [self initLogger];
    }
    
    if (!sharedLogger.currentDataFile)
    {
        sharedLogger.currentDataFile = [sharedLogger getNewDataFileName];
        [sharedLogger.fileManager createFileAtPath:sharedLogger.currentDataFile contents:nil attributes:nil];
    }
    
    NSString *outputString = [NSString stringWithFormat:@"%@: %@\n",[[NSDate date] description],message];
    
    NSLog(@"file: %@ size: %@",sharedLogger.currentDataFile,[[sharedLogger.fileManager attributesOfItemAtPath:sharedLogger.currentDataFile error:nil] valueForKey:@"NSFileSize"]);
    NSFileHandle *output = [NSFileHandle fileHandleForUpdatingAtPath:sharedLogger.currentDataFile];
    [output seekToEndOfFile];
    [output writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [output closeFile];
    
    
    // Upload log to Dropbox
    //[[sharedLogger dbClient] uploadFile:[sharedLogger.currentDataFile lastPathComponent] toPath:@"/" withParentRev:nil fromPath:sharedLogger.currentDataFile];
    
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


-(NSString*)getNewDataFileName {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy_MM_dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH_mm_ss"];
    
    NSDate *now = [NSDate date];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    NSString *fileStr = [NSString stringWithFormat:@"%@_%@.txt", theDate,theTime];
    
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
