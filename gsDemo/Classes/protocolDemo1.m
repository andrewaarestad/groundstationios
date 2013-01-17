//
//  protocolDemo1.m
//  MCHP MFI
//
//  Created by Joseph Julicher on 6/10/10.
//  Copyright 2010 Microchip Technology. All rights reserved.
//

#import "protocolDemo1.h"
#import "Logger.h"

@interface protocolDemo1 ()

@property (readwrite) uint8_t AccStatus;
@property (readwrite) uint8_t AccMajor;
@property (readwrite) uint8_t AccMinor;
@property (readwrite) uint8_t AccRev;
@property (readwrite) uint8_t BoardID;
@property (readwrite) float temperature;
@property (readwrite) int pot;
@property (readwrite) uint8_t switches;

@end

@implementation protocolDemo1

@synthesize AccStatus;
@synthesize AccMajor;
@synthesize AccMinor;
@synthesize AccRev;
@synthesize BoardID;
@synthesize temperature;
@synthesize pot;
@synthesize switches;


- (void) setVolume:(float) v
{
	uint8_t buffer[6];
	bzero(buffer, sizeof(buffer));
	
	if(v < 0) v = 0;
	if(v > 1) v = 1;
	buffer[0] = 9;
	buffer[1] = 255 - (255 * v);
	@synchronized (self)
	{
	  [self queueTxBytes:[NSData dataWithBytes:buffer length:6]];
	}
}

- (void) setLeds:(uint8_t)l
{
	uint8_t buffer[6];
	bzero(buffer, sizeof(buffer));

	buffer[0] = 2;
	buffer[1] = l;
	buffer[2] = counter ++;
	@synchronized (self)
	{
		[self queueTxBytes:[NSData dataWithBytes:buffer length:6]];
	}

}

#define kUPDATERATE_FAST 0.005 // seconds
#define kUPDATERATE_SLOW 0.100 // seconds

- (void) updateData
{
	char requestTemp[6] = {5,0,0,0,0,0};
	char requestPot[6] = {7,0,0,0,0,0};
	char requestDebugInstrum[6] = {20,0,0,0,0,0};
	int c = 0;
	float updateRate = kUPDATERATE_SLOW;
	thePool = [[NSAutoreleasePool alloc] init];

	while (1) 
	{
		@synchronized (self)
		{	
			if(BoardID == MFI_UNKNOWN_HW)
			{
				char requestStatus[] = {0,0,0,0,0,0};
				[self queueTxBytes:[NSData dataWithBytes:requestStatus length:sizeof(requestStatus)]];
			}
			
			if ((++c % (int)(1.0/updateRate))==0) // update the temperature once per second
			{
                //NSLog(@"Requesting debug instrum...");
				//[self queueTxBytes:[NSData dataWithBytes:requestTemp length:sizeof(requestTemp)]];
                //[self queueTxBytes:[NSData dataWithBytes:requestPot length:sizeof(requestPot)]];
				[self queueTxBytes:[NSData dataWithBytes:requestDebugInstrum length:sizeof(requestDebugInstrum)]];
			}
        
		}
		if (BoardID == MFI_16_BIT_HW) {
			updateRate = kUPDATERATE_FAST;
		}
		else {
			updateRate = kUPDATERATE_SLOW;
		}
		[NSThread sleepForTimeInterval:updateRate];
	}
}

- (int) readData:(NSData *) data
{
    //NSLog(@"readData");
	int ret;
	ret = 0;
	if([data length] >= 6)
	{
        int expectedNumBytes = [data length];
        
		NSRange r;
		uint8_t buf[expectedNumBytes];
		r.location = 0;
		r.length = expectedNumBytes;
		ret = r.length;
        
        
        
		[data getBytes:buf length:expectedNumBytes]; // Extract the complete Packet
        
        uint8_t messageType = buf[0];
        
        
        
		// process data received from the accessory
		switch(messageType)
		{
			case 1: // Accessory Ready
				@synchronized (self)
				{
					AccStatus = buf[1];
					AccMajor = buf[2];
					AccMinor = buf[3];
					AccRev = buf[4];
					BoardID = buf[5];
				}
				break;
			case 4: // ReturnAccessorySwitches
				@synchronized (self)
				{
					switches = buf[1];
				}
				break;
			case 6: // ReturnTemperature
				{
					float temp;
					temp = buf[2];
					temp += ((float)(buf[3]))/10.0;
					if(buf[1])
						temp *= -1;
					@synchronized (self)
					{
						temperature = temp;
					}
				}
				break;
			case 8: // ReturnPotentiometer
				{
					int p;
					p = buf[1] * 256 + buf[2];
					if(p < 0) p = 0;
					@synchronized (self)
					{
						pot = p;
					}
				}
				break;
            case 21: // ReturnDebugInstrum
                {
                    //char dataBuffer[expectedNumBytes];
                    char tempChar;
                    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:1];
                    NSString *message = [NSString string];
                    for (int bufIdx = 0;bufIdx < expectedNumBytes-1;bufIdx++)
                    {
                        tempChar = (char)buf[bufIdx+1];
                        
                        // Messages are delimited by \0
                        if (tempChar == '\0')
                        {
                            [messages addObject:message];
                            message = [NSString string];
                        }
                        else
                        {
                            message = [NSString stringWithFormat:@"%@%c",message,tempChar];
                        }
                    }
                    [messages addObject:message];
                    
                    //NSString *parsedMessage = [NSString stringWithUTF8String:(const char *)dataBuffer];
                    //NSString *parsedMessage = [NSString stringWithCString:(const char *)dataBuffer encoding:NSUTF8StringEncoding];
                    
                    // remove final character since stringWithUTF8String converts the trailing NULL to an 'S' for some reason
                    //NSString *finalMessage = [parsedMessage substringToIndex:[parsedMessage length]-1];
                    
                    int idx = 1;
                    for (NSString *msg in messages)
                    {
                        NSLog(@"Received message %i: %@",idx,msg);
                        //[Logger log:msg];
                        idx++;
                    }
                }
                break;
			default: // unknown command
				NSLog(@"%@ : Unknown Message: %d",theProtocol,buf[0]);
				break;
		}
	}
	return ret;
}

- (id) init
{
	self = [super initWithProtocol:@"com.microchip.ipodaccessory.demo1"];
	NSLog(@"starting update thread");
	updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateData) object:nil];
	[updateThread start];

	BoardID = MFI_UNKNOWN_HW;
	// 
	return self;
	
}

-(void) dealloc
{
	[thePool drain];
}

@end
