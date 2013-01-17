//
//  MAVParseMessage.h
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAVMessage.h"
#import "MAVMessageTypes.h"

@interface MAVParseMessage : NSObject
{
    MAVHeartbeat *testMessage;
}

+(id)parseMAVMessage:(NSData *)data;




@end
