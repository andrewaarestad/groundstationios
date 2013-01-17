//
//  protocolDemo1.h
//  MCHP MFI
//
//  Created by Joseph Julicher on 6/10/10.
//  Copyright 2010 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mchp_mfi.h"

#define MFI_UNKNOWN_HW 0
#define	MFI_8_BIT_HW 2
#define MFI_16_BIT_HW 3

@interface protocolDemo1 : mchp_mfi {
    uint8_t AccStatus;
    uint8_t AccMajor;
    uint8_t AccMinor;
    uint8_t AccRev;
    uint8_t BoardID;
	
	NSAutoreleasePool *thePool;
	NSThread *updateThread;
	
    float temperature;
    int pot;
    uint8_t switches;
	uint8_t counter;
}

@property (readonly) uint8_t AccStatus;
@property (readonly) uint8_t AccMajor;
@property (readonly) uint8_t AccMinor;
@property (readonly) uint8_t AccRev;
@property (readonly) uint8_t BoardID;
@property (readonly) float temperature;
@property (readonly) int pot;
@property (readonly) uint8_t switches;

- (void) updateData;
- (void) setVolume:(float)v;
- (void) setLeds:(uint8_t)l;

@end
