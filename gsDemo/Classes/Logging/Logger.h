//
//  Logger.h
//  MCHP MFI
//
//  Created by Andrew Aarestad on 1/14/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject



+(void)log:(NSString*)message;



@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSString *logsPath;
@property (nonatomic, strong) NSString *currentDataFile;

@end
