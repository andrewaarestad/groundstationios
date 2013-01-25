//
//  MAVLinkHeader.m
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 et AL. LLC. All rights reserved.
//

#import "MAVMessage.h"

@implementation MAVMessage


- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

+(MAVMessage *)initWithData:(NSData *) data
{
    uint16_t checksum; /// sent at end of packet
	uint8_t magic;   ///< protocol magic marker
	uint8_t len;     ///< Length of payload
	uint8_t seq;     ///< Sequence of packet
	uint8_t sysid;   ///< ID of message sender system/aircraft
	uint8_t compid;  ///< ID of the message sender component
	uint8_t msgid;   ///< ID of message in payload

    MAVMessage *message = [[self alloc] init];
    
    @try
    {
        //FIXME create macro that adds correct number of bytes based
        //on datatype
        //Bring in magic number
        [data getBytes:&magic range:NSMakeRange(0, 1)];
        message.magic = [NSNumber numberWithUnsignedChar:magic];
        //Bring in message length
        [data getBytes:&len range:NSMakeRange(1, 1)];
        message.len = [NSNumber numberWithUnsignedChar:len];
        //Bring in packet sequence
        [data getBytes:&seq range:NSMakeRange(2, 1)];
        message.seq = [NSNumber numberWithUnsignedChar:seq];
        //Bring in system id
        [data getBytes:&sysid range:NSMakeRange(3, 1)];
        message.sysid = [NSNumber numberWithUnsignedChar:sysid];
        //Bring in sender component
        [data getBytes:&compid range:NSMakeRange(4, 1)];
        message.compid = [NSNumber numberWithUnsignedChar:compid];
        //Bring in message ID
        [data getBytes:&msgid range:NSMakeRange(5, 1)];
        message.msgid = [NSNumber numberWithUnsignedChar:msgid];
    }
    @catch (NSException *e) {
        NSLog(@"Warning: Tried to init NAVMessage with invalid data.");
        return nil;
    }
    
    //Verify length
    NSInteger headerEndIdx = 6;
    NSInteger expectedEndIdx = headerEndIdx + len;
    NSInteger dataLength = [data length];
    
    //Verify checksum
    //TODO Verify checksum
    
    if(expectedEndIdx == dataLength)
    {
        //The message length is as expected process message
        if(expectedEndIdx <= dataLength)
        {
            @try
            {
                message.payload = [NSData dataWithData:[data subdataWithRange:NSMakeRange(headerEndIdx, expectedEndIdx)]];
            }
            @catch (NSException *e) {
                NSLog(@"Warning: MAVMessage had invalid payload.");
            }
        }
        else
        {
            NSLog(@"Incomplete message, dropping");
            message = nil;
        }
    }
    else
    {
        NSLog(@"Warning: Length is differnt than expect\nExpected: %i got %i",expectedEndIdx,dataLength);
        
        @try
        {
            message.payload = [NSData dataWithData:[data subdataWithRange:NSMakeRange(headerEndIdx, (dataLength - headerEndIdx))]];
            
        }
        @catch (NSException *e) {
            NSLog(@"Warning: MAVMessage had invalid payload.");
        }
    }
    return message;
}





@end
