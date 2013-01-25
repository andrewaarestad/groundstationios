//
//  Logger.h
//  MCHP MFI
//
//  Created by Andrew Aarestad on 1/14/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface Logger : NSObject <DBRestClientDelegate>
{
    DBRestClient *restClient;
}


+(void)logDebug:(NSString*)message;
+(void)logData:(NSData*)data;
+(void)userPressedNewLogButton;



@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSString *logsPath;
@property (nonatomic, strong) NSString *currentDataFile;
@property (nonatomic, strong) NSString *currentLogFile;

@property (nonatomic, strong) NSDate *lastDisplayUpdateTime;
@property (nonatomic) double lastDisplayUpdateFileSize;
@property (nonatomic, strong) NSString *lastDisplayUpdateFileName;

@property (nonatomic, strong) NSDate *currentDisplayUpdateTime;
@property (nonatomic) double currentDisplayUpdateFileSize;
@property (nonatomic, strong) NSString *currentDisplayUpdateFileName;
@property (nonatomic, strong) NSString *currentBytesPerSec;

- (DBRestClient*)dbClient;

@end
