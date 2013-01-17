//
//  mchp_packet.h
//  MCHP MFI
//
//  Created by jjulicher on 9/10/09.
//  Copyright 2009 Microchip Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExternalAccessory/ExternalAccessory.h"

typedef struct
{
    BOOL sw1;
    BOOL sw2;
    BOOL sw3;
    BOOL sw4;
}switch_t;

const NSString *MCHP_PROTOCOL_STRING = @"com.microchip.ipodaccessory.demo1";

@interface mchp_packet : NSObject 
{
    switch_t switch_values;
    int     theTemperature;
    int     thePotPosition;
    
    EAAccessory *ea;
    
    BOOL packetInReceiveQueue;
    
    NSMutableArray *rxPacketBuffer;
    NSMutableArray *txPacketBuffer;
    NSData *rxData;
    NSData *txData;
}

- (id) init;
- (BOOL) accessoryAttached;
- (NSData *) getPacket;
- (void) sendPacket:(NSData *);

@end
