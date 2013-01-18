//
//  MAVHeartbeat.m
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import "MAVHeartbeat.h"
//Here to avoid circular reference
#import "MAVMessage.h"


@implementation MAVHeartbeat

+(MAVHeartbeat *)initWithMAVMsg:(MAVMessage *) mavMsg
{
    uint8_t     type;               //Type of the MAV (quadrotor, helicopter, etc., up to 15 types, defined in MAV_TYPE ENUM)
    uint8_t     autopilot;          //Autopilot type / class. defined in MAV_AUTOPILOT ENUM
    uint8_t     base_mode;          //System mode bitfield, see MAV_MODE_FLAGS ENUM in mavlink/include/mavlink_types.h
    uint32_t    custom_mode;        //A bitfield for use for autopilot-specific flags.
    uint8_t     system_status;      //System status flag, see MAV_STATE ENUM
    uint8_t     mavlink_version;	//uint8_t_mavlink_version	MAVLink version, not writable by user, gets added by protocol
                                    //because of magic data type: uint8_t_mavlink_version
    
    [mavMsg.payload getBytes:&custom_mode range:NSMakeRange(0, 4)];
    [mavMsg.payload getBytes:&type range:NSMakeRange(4, 1)];
    [mavMsg.payload getBytes:&autopilot range:NSMakeRange(5, 1)];
    [mavMsg.payload getBytes:&base_mode range:NSMakeRange(6, 1)];
    [mavMsg.payload getBytes:&system_status range:NSMakeRange(7, 1)];
    [mavMsg.payload getBytes:&mavlink_version range:NSMakeRange(8, 1)];
    
    
    NSLog(@"MavCustom Mode %i MavType %i, MavAutopilot %i MavBaseMode %i MavSysStatus %i MavLinkVersion %i",custom_mode,type,autopilot,base_mode,system_status,mavlink_version);
    
    //This will need to change
    return (MAVHeartbeat *)mavMsg;
}



@end
