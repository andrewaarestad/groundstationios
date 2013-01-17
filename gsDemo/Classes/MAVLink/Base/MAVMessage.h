//
//  MAVLinkHeader.h
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAVMessage : NSObject {
	NSNumber *checksum; ///uint16_t sent at end of packet
	NSNumber *magic;   ///uint8_t protocol magic marker (254 for 1.0, 85 for 0.9)
	NSNumber *len;     ///uint8_t Length of payload
	NSNumber *seq;     ///uint8_t Sequence of packet
	NSNumber *sysid;   ///uint8_t ID of message sender system/aircraft
	NSNumber *compid;  ///uint8_t ID of the message sender component
	NSNumber *msgid;   ///uint8_t ID of message in payload
    NSData *payload;    //Message payload
	//uint64_t payload64[(MAVLINK_MAX_PAYLOAD_LEN+MAVLINK_NUM_CHECKSUM_BYTES+7)/8];
}

@property (nonatomic, strong) NSNumber *checksum;
@property (nonatomic, strong) NSNumber *magic;
@property (nonatomic, strong) NSNumber *len;
@property (nonatomic, strong) NSNumber *seq;
@property (nonatomic, strong) NSNumber *sysid;
@property (nonatomic, strong) NSNumber *compid;
@property (nonatomic, strong) NSNumber *msgid;
@property (nonatomic, strong) NSData *payload;

+(MAVMessage *)initWithData:(NSData *) data;

@end
