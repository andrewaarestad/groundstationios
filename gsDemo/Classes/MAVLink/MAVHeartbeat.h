//
//  MAVHeartbeat.h
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAVMessage.h"
#import "MAVMessageTypes.h"
#import "mavlink_types.h"
#import "common.h"

@interface MAVHeartbeat : MAVMessage

@property (nonatomic) uint32_t custom_mode;
@property (nonatomic) enum MAV_TYPE type;
@property (nonatomic) enum MAV_AUTOPILOT autopilot;
@property (nonatomic) enum MAV_MODE_FLAG base_mode;
@property (nonatomic) enum MAV_STATE system_status;
@property (nonatomic, strong) NSNumber *mavlink_version;

+(MAVHeartbeat *)initWithMAVMsg:(MAVMessage *) mavMsg;

@end
