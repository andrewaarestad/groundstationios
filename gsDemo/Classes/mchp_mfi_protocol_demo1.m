//
//  mchp_mfi_protocol.m
//  MCHP MFI
//
//  Created by jjulicher on 9/10/09.
//  Copyright 2009 Microchip Technology Inc. All rights reserved.
//

#import "mchp_packet.h"


@implementation mchp_packet

- (id) init
{
    rxPacketBuffer = [[NSMutableArray allocWithCapacity:32] autorelease]; // initially allocate the queue with 32 slots
    txPacketBuffer = [[NSMutableArray allocWithCapacity:32] autorelease]; // initially allocate the queue with 32 slots
    
    eas = [self openSessionForProtocol:@"com.microchip.ipodaccessory.demo1"];
    if(eas == nil)
    {
        // we did not find an appropriate accessory
        // configure a notification event to alert us later
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(accessoryDidConnect:)
                                                     name:EAAccessoryDidConnectNotification object:nil];
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    }
    return self;
}


/***********************************************************************/
#pragma mark External Accessory Basic Identification & stream handling
/***********************************************************************/

- (EASession *)openSessionForProtocol:(NSString *)protocolString 
{
    NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager]
                            connectedAccessories];
    EAAccessory *accessory = nil;
    EASession *session = nil;
    
    for (EAAccessory *obj in accessories)
    {
        if ([[obj protocolStrings] containsObject:protocolString])
        {
            accessory = obj;
            break;
        }
    }
    
    if (accessory)
    {
        session = [[EASession alloc] initWithAccessory:accessory
                                           forProtocol:protocolString];
        if (session)
        {
            [[session inputStream] setDelegate:self];
            [[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                             forMode:NSDefaultRunLoopMode];
            [[session inputStream] open];
            [[session outputStream] setDelegate:self];
            [[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                              forMode:NSDefaultRunLoopMode];
            [[session outputStream] open];
            [session autorelease];
        }
    }
    return session;
}

#pragma mark Stream Processing
// Handle communications from the streams.
- (void)stream:(NSStream*)stream handleEvent:(NSStreamEvent)streamEvent
{
    uint8_t buf[512];
    uint8_t byte;
    int preamble;
    unsigned int len = 0;
    NSRange range;
    
    switch (streamEvent)
    {
        case NSStreamEventHasBytesAvailable:
            // Process the incoming stream data.
            // get the new bytes from the stream
            len = [(NSInputStream *)stream read:buf maxLength:sizeof(buf)];
            
            // allocate a NSMutableData block to hold the bytes (if the previous block was emptied)
            if(!rxData)
            {
                rxData = [[NSMutableData data] retain];
            }
            if(len)
            {
                // copy my new data into the NSMutableData array
                [rxData appendBytes:(const void*)buf length:len];
                
                preamble = 0;
                do
                {
                    // remove the oldest byte...
                    range.location = 0;
                    range.length = [data length];
                    preamble <<= 8;
                    preamble &= 0x0000FF00;
                    [data getBytes:&byte length:1];
                    preamble |= byte;
                    range.location ++;
                    range.length --;
                    [data setData:[data subdataWithRange:range]];
                    if(preamble == 0x00005AA5) // we found a packet
                    {
                        receivedAccPkt = true;
                        [rxData getBytes:buf length:6]; // Extract the complete Packet
                        [rxPacketBuffer addObject: [NSData dataWithBytes:buf length:6]; // queue the packet sans preamble
                        packetInReceiveQueue = true;
                    }
                }
                while([data length] >= 6); // we may have a packet in the buffer.                
            }
            else
            {
                NSLog(@"no buffer!");
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            // is there data remaining from a previous transmission?
                         if(txData)
                         {
                             if([txData size])
                             {
                                 
                             }
                         }
            // if not then is there another packet in the queue?
            // Send the next queued command.
            if( [txPacketBuffer count] )
            {
                int len,sent;
                NSData *dataBlock = [txPacketBuffer removeObjectAtIndex:0];
                len = [dataBlock size];
                [dataBlock getBytes:&buf[2] length:len];
                buf[0] = 0x5A;
                buf[1] = 0xA5;
                sent = [[eas outputStream] write:(const uint8_t *)buf maxLength:len];
                if(sent < len)
                {
                    // The stream did not accept all of the data
                    // create an NSData object to hold the remainder of the stream
                }
                [dataBlock release];
            }
            else // mark the stream as ready to accept data
            {
                streamReady = true;
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Stream error Occured");
            break;
        default:
            break;
    }
}

#pragma mark accessory notifications

- (void) accessoryDidDisconnect:(EAAccessory *) accessory
{
    // convienience method called when any accessory disconnects
    /* this is a delgate function and not the notification function */
    /* you can pick the notification or the delegate but don't do both */
    eas = nil; // I hope this is a good idea
}

/* this is the notification function if we register for the did disconnect notification event */
/* this is not used because we are using the delegate function */
- (void)accessoryDidDisconnectNotification:(NSNotification *)notification
{
    
}

- (void)accessoryDidConnect:(NSNotification *)notification
{
    // This method is recieved in response to the EAAccessoryDidCOnnectNotification event
    eas = [self openSessionForProtocol:@"com.microchip.ipodaccessory.demo1"];
    if(eas!= nil)
    {
        // Found an accessory
        // nothing to do yet
    }
}

@end
