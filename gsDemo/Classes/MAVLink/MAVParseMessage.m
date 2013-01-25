//
//  MAVParseMessage.m
//  MCHP MFI
//
//  Created by BRYAN GALUSHA on 1/17/13.
//  Copyright (c) 2013 Microchip Technology. All rights reserved.
//

#import "MAVParseMessage.h"
#import "Logger.h"

@implementation MAVParseMessage

+(id)parseMAVMessage:(NSData *)data
{
    //Chop off the message id byte on the front
    NSData *mavData = [data subdataWithRange:NSMakeRange(1, [data length]-1)];
    
    // Send to data log
    [Logger logData:mavData];
    
    MAVMessage *mavMessage = [MAVMessage initWithData:mavData];
    
    if (mavMessage)
    {
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
    else
    {
        NSLog(@"MAVParseMessage: Skipping invalid data.");
        return nil;
    }
}
@end
