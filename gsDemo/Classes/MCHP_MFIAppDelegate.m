//
//  MCHP_MFIAppDelegate.m
//  MCHP MFI
//
//  Created by Joseph Julicher on 8/28/09.
//  Copyright Microchip Technology Inc. 2009. All rights reserved.
//

#import "MCHP_MFIAppDelegate.h"
#import "MCHP_MFIViewController.h"

@implementation MCHP_MFIAppDelegate

@synthesize window;
@synthesize viewController;

#define kTimerRate 0.1

#pragma mark periodic timer
// configure a periodic timer to poll the accessory
- (void)appUpdate:(NSTimer*)theTimer
{
    
	static float volume_pv = 0;
	static uint8_t led_pv = 0;
	if([demo isConnected])
	{
		// autodismiss the view if the demo connects
		if (alertView.visible) {
			[alertView dismissWithClickedButtonIndex:0 animated:YES];
		}
		
		if ([viewController led] != led_pv) {
			led_pv = [viewController led];
			[demo setLeds:led_pv];
		}
		if ([viewController volume] != volume_pv) {
			volume_pv = [viewController volume];
			[demo setVolume:volume_pv];
		}
				
		[viewController graph_temperature:demo.temperature 
								   andPot: demo.pot ];
		[viewController meter_temperature:demo.temperature 
								   andPot: demo.pot ];
		[viewController updateStateSW1:demo.switches & 0x01 
								   SW2:demo.switches & 0x02 
								   SW3:demo.switches & 0x04 
								   SW4:demo.switches & 0x08];
		[viewController updateInfoName:[demo name] 
						  manufacturer:[demo manufacturer] 
						   modelNumber:[demo modelNumber] 
						  serialNumber:[demo serialNumber] 
					  firmwareRevision:[demo firmwareRevision] 
					  hardwareRevision:[demo hardwareRevision]
					   BoardIdentifier:[demo BoardID]==0?@"Unknown":[demo BoardID]==2?@"8-Bit":@"16/32-Bit"
							updateRate:[demo BoardID]==3?@"5 mSec":@"100 mSec"];
	}
    else
    {
		// Nothing is connected so show the alert
		
		if (![alertView isVisible]) {
			[alertView show];
		}
		
		
        [viewController updateInfoName:@"-" 
                          manufacturer:@"-" 
                           modelNumber:@"-" 
                          serialNumber:@"-" 
                      firmwareRevision:@"-" 
                      hardwareRevision:@"-"
					   BoardIdentifier:@"-"
							updateRate:@"-"];
    }
}


- (void) volumeUpdate:(float) v
{
	[demo setVolume:v];
}

#pragma mark initialization

- (BOOL)application:(UIApplication *) application 
	didFinishLaunchingWithOptions:(NSDictionary *) launchOptions 
{    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    streamReady = false;
		
    // startup the external accessory manager
	demo = [[protocolDemo1 alloc] init];
	
	alertView = [[UIAlertView alloc] initWithTitle:@"Hardware Not Found"
										   message:@"No matching accessory hardware is attached"
										  delegate:self 
								 cancelButtonTitle:@"Retry" 
								 otherButtonTitles:@"More Info", nil];

		
	return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSLog(@"local notification");
}

- (void) applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"Terminating");
}

-(void) applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"Entering Foreground");
}

-(void) applicationDidEnterBackground:(UIApplication *)application
{
	NSLog(@"Entered Background");
	
	// if we shutdwon the update timer here, the graphs will continue until the application is no longer visible
	[updateTimer invalidate]; // shutdown the timer;
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	NSLog(@"Going Inactive");
	if (alertView.visible) {
		[alertView dismissWithClickedButtonIndex:0 animated:YES];
	}
	
	// if we shutdown the update timer here then the graphs will freeze when you are viewing the active tasks
	//[updateTimer invalidate]; // shutdown the timer;
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"Became Active");
	// startup my application update timer

    updateTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerRate // every 100msecs
												   target:self
												 selector:@selector(appUpdate:)
												 userInfo:nil
												  repeats:YES];
	
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	switch (buttonIndex) {
		case 0:
			break;
		case 1:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.microchip.com/mfi"]];
		default:
			break;
	}
}
@end
