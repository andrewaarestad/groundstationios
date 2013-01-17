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

@interface MAVHeartbeat : MAVMessage

+(MAVHeartbeat *)initWithMAVMsg:(MAVMessage *) mavMsg;

@end
