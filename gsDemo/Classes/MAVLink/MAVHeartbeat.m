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
#import "Logger.h"

@implementation MAVHeartbeat

+(MAVHeartbeat *)initWithMAVMsg:(MAVMessage *) mavMsg
{
    uint32_t    custom_mode;        //A bitfield for use for autopilot-specific flags.
    uint8_t     type;               //Type of the MAV (quadrotor, helicopter, etc., up to 15 types, defined in MAV_TYPE ENUM)
    uint8_t     autopilot;          //Autopilot type / class. defined in MAV_AUTOPILOT ENUM
    uint8_t     base_mode;          //System mode bitfield, see MAV_MODE_FLAG ENUM in mavlink/include/mavlink_types.h
    uint8_t     system_status;      //System status flag, see MAV_STATE ENUM
    uint8_t     mavlink_version;	//uint8_t_mavlink_version	MAVLink version, not writable by user, gets added by protocol
                                    //because of magic data type: uint8_t_mavlink_version
    
    MAVHeartbeat *mavHeartbeat = [[MAVHeartbeat alloc] init];
    
    @try
    {
        [mavMsg.payload getBytes:&custom_mode range:NSMakeRange(0, 4)];
        mavHeartbeat.custom_mode = custom_mode;
        [mavMsg.payload getBytes:&type range:NSMakeRange(4, 1)];
        mavHeartbeat.type = type;
        [mavMsg.payload getBytes:&autopilot range:NSMakeRange(5, 1)];
        mavHeartbeat.autopilot = autopilot;
        [mavMsg.payload getBytes:&base_mode range:NSMakeRange(6, 1)];
        mavHeartbeat.base_mode = base_mode;
        [mavMsg.payload getBytes:&system_status range:NSMakeRange(7, 1)];
        mavHeartbeat.system_status = system_status;
        [mavMsg.payload getBytes:&mavlink_version range:NSMakeRange(8, 1)];
        mavHeartbeat.mavlink_version = [NSNumber numberWithUnsignedChar:mavlink_version];
        NSString *logString = [NSString stringWithFormat:@"MavCustom Mode %i MavType %i, MavAutopilot %i MavBaseMode %i MavSysStatus %i MavLinkVersion %i",custom_mode,type,autopilot,base_mode,system_status,mavlink_version];
        NSLog(@"%@",logString);
        
        
        [Logger logDebug:logString];
        
    }
    @catch (NSException *e) {
        [Logger logDebug:[NSString stringWithFormat:@"Warning: Invalid MAVLink data received, discarding: %@",[e description]]];
        return nil;
    }
    
    
    //This will need to change
    return (MAVHeartbeat *)mavMsg;
}



@end
