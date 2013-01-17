//
//  mchp_mfi.m
//  MCHP MFI
//
//  Created by Joseph Julicher on 6/10/10.
//  Copyright 2010 Microchip Technology. All rights reserved.
//

#import "mchp_mfi.h"

@implementation mchp_mfi


// OVERLOAD ME!!
- (int) readData:(NSData *) data
{
	return [data length];
}

- (id) initWithProtocol:(NSString *)protocol
{
	theProtocol = protocol;
	// see if an accessory is already attached
	eas = [self openSessionForProtocol:theProtocol];
    if(eas == nil)
    {
        // we did not find an appropriate accessory
    }
	// install notification events.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(accessoryDidConnect:)
												 name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidDisconnect:)
                                                 name:EAAccessoryDidDisconnectNotification object:nil];
    
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    return self;	
}

- (bool) isConnected
{
	return [[eas accessory] isConnected];
}

- (NSString *) name { return (eas)?[[eas accessory] name]:@"-"; }
- (NSString *) manufacturer { return (eas)?[[eas accessory] manufacturer]:@"-";}
- (NSString *) modelNumber {return (eas)?[[eas accessory] modelNumber]:@"-";}
- (NSString *) serialNumber {return (eas)?[[eas accessory] serialNumber]:@"-";}
- (NSString *) firmwareRevision {return (eas)?[[eas accessory] firmwareRevision]:@"-";}
- (NSString *) hardwareRevision {return (eas)?[[eas accessory] hardwareRevision]:@"-";}

/***********************************************************************/
#pragma mark External Accessory Basic Identification 
/***********************************************************************/

- (EASession *)openSessionForProtocol:(NSString *)protocolString 
{
    NSLog(@"getting a list of accessories");
    NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager]
                            connectedAccessories];
	
    EAAccessory *accessory = nil;
    EASession *session = nil;
    
	NSLog(@"Found %d accessories",[accessories count]);
    NSLog(@"looking for %@",protocolString);
    
	for (EAAccessory *obj in accessories)
    {
		NSArray *sa = [obj protocolStrings];
		NSLog(@"a string dump of %d strings",[sa count]);
		
		for(NSString *s in sa)
		{
			NSLog(@"%@",s);
		}
		
        if ([[obj protocolStrings] containsObject:protocolString])
        {
            accessory = obj;
            break;
        }
    }
    
    NSLog(@"Scanned the list of accessories");
    if (accessory)
    {
        session = [[EASession alloc] initWithAccessory:accessory
                                           forProtocol:protocolString];
        if (session)
        {
            NSLog(@"opening the streams for this accessory");
            [[session inputStream] setDelegate:self];
            [[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                             forMode:NSDefaultRunLoopMode];
            [[session inputStream] open];
            [[session outputStream] setDelegate:self];
            [[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                              forMode:NSDefaultRunLoopMode];
            [[session outputStream] open];
            [session retain];
            streamReady = true;
            receivedAccPkt = true;
        }
    }
    return session;
}

#pragma mark Stream Processing
// Handle communications from the streams.
- (void)stream:(NSStream*)stream handleEvent:(NSStreamEvent)streamEvent
{
    uint8_t buf[20];
    unsigned int len = 0;
	int count = 0;
    
    switch (streamEvent)
    {
        case NSStreamEventHasBytesAvailable:
            // Process the incoming stream data.
            // get the new bytes from the stream
            while((len = [(NSInputStream *)stream read:buf maxLength:sizeof(buf)]))
            {
				if(rxData == nil) rxData = [[NSMutableData data] retain];
				[rxData appendBytes:buf length:len];
				count += len;
			}
			
			// loop here to unload the receive queue
			// find a preamble
			const char preambleBytes[] = {0x5A,0xA5};
			NSRange r = {0,sizeof(preambleBytes)};
			NSData	*pd = [NSData dataWithBytes:preambleBytes length:2];

			r.length = 2;
			while ((r.length + r.location) < [rxData length])
			{
				if([[rxData subdataWithRange:r] isEqualToData:pd])
				{
					if( (r.location + r.length) > [rxData length])
						break;
					r.location += 2;
					r.length = [rxData length] - r.location;
					len = [self readData:[rxData subdataWithRange:r]];
					r.location += len;
				}
				else
				{
					r.location ++;
				}
				
				r.length = 2;
			}
            
			if(r.location >= [rxData length])
			{
				[rxData release];
				rxData = nil;
			}
			else 
			{
				// reset the receiver with the bytes that were not consumed.
                if (r.location + r.length <= rxData.length)
                {
                    [rxData setData:[rxData subdataWithRange:r]];
                }
                else
                {
                    NSLog(@"WARNING: Unhandled case of received data, not consumed...");
                }
			}

			
            break;
        case NSStreamEventHasSpaceAvailable:
            // Send the next queued command.
			@synchronized(self)
			{
				[self txBytes];
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

/* this is the notification function if we register for the did disconnect notification event */
- (void)accessoryDidDisconnect:(NSNotification *)notification
{
    NSLog(@"Accessory Disconnected");
    [[eas inputStream] close];
    [[eas outputStream] close];
    [eas release];
    eas = nil;
}

- (void)accessoryDidConnect:(NSNotification *)notification
{
    NSLog(@"Accessory Connected");
    // This method is recieved in response to the EAAccessoryDidCOnnectNotification event
    eas = [self openSessionForProtocol:theProtocol];
    if(eas != nil)
    {
        // YEA we got an accessory
        // nothing to do yet
    }
}

#pragma mark Stream Handling TX and RX functions

-(void) queueTxBytes:(NSData *)buf
{
    unsigned char p[] = {0x5A,0xA5};
	
	if([self isConnected])
	{
		if(txData!=nil)
		{
			[txData appendData:[NSData dataWithBytes:p length:sizeof(p)]];
			[txData appendData:buf];
		}
		else
		{
			txData = [NSMutableData dataWithBytes:p length:sizeof(p)];
			[txData appendData:buf];
			[txData retain];
			if([[eas outputStream] hasSpaceAvailable])
			{
				@synchronized(self)
				{
					[self txBytes]; // jumpstart the transmitter
				}
			}
		}
	}    
}

-(void) txBytes
{
    int len;
    
    if(txData!=nil)
    {
        if([txData length])
        {
            //FIXME this will error out if the Mfi device disconnects unexpectedly
            len = [[eas outputStream] write:[txData bytes] maxLength:[txData length]];

            if (len < [txData length])
			{
				NSRange range;
				range.location = len;
				range.length = [txData length] - len;
                // some data remaining
				[txData setData:[txData subdataWithRange:range]];
            }
            else
			{ // no data remaining
				[txData release];
				txData = nil;
            }
        }
    }	
}

typedef enum{ find_preamble,get_com_cmd,get_mddfs_cmd,get_mddfs_data } mddfs_rx_states_t;
-(void) rxBytes:(const void*)buf length:(int)len
{
    static mddfs_rx_states_t receive_state = find_preamble;
	
    if (receive_state != find_preamble) 
    {
        [rxData appendBytes:buf length:len];
    }
    else // look for the preamble
    {
        for(int x=1;x<len;x++)
        {
            if(((uint8_t *)buf)[x-1] == 0x5A && ((uint8_t *)buf)[x] == 0xA5)
            {
                receive_state = get_com_cmd;
                rxData = [[NSMutableData data] retain];
                [rxData appendBytes:&((uint8_t *)buf)[x+1] length:len-x-1];
                break;
            }
        }            
    }
}

@end
