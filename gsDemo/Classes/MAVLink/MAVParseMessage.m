//
//  MAVParseMessage.m
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import "MAVParseMessage.h"

@implementation MAVParseMessage

+(id)parseMAVMessage:(NSData *)data
{
    //Chop off the message id byte on the front
    NSData *MAVData = [data subdataWithRange:NSMakeRange(1, [data length]-1)];
    
    MAVMessage *mavMessage = [MAVMessage initWithData:MAVData];
    
    switch ([mavMessage.msgid integerValue]) {
            //TODO: Change this to an enum ASAP
        case 0:
        {
            MAVHeartbeat *mavHeartbeat = [MAVHeartbeat initWithMAVMsg:mavMessage];
            return mavHeartbeat;
            break;
        }
            
        default:
        {
            NSLog(@"MessageId: %@ not yet handled",mavMessage.msgid);
            return mavMessage;
            break;
        }
    }
}
@end
