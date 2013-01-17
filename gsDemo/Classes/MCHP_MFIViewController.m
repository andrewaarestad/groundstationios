//
//  MCHP_MFIViewController.m
//  MCHP MFI
//
//  Created by Joseph Julicher on 8/28/09.
//  Copyright Microchip Technology Inc. 2009. All rights reserved.
//

#import "MCHP_MFIViewController.h"

@implementation MCHP_MFIViewController

@synthesize volume;
@synthesize led;
@synthesize volumeUpdater;
@synthesize ledUpdater;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[volumeSlider setValue:4.0/32];
    [graph_view setMaxScale1:1024];
    [graph_view setMinScale1:0];
    [graph_view setMaxScale2:125];
	[graph_view setMinScale2:-55];   
    [meter_view setMaxScale1:1024];
    [meter_view setMinScale1:0];
    [meter_view setMaxScale2:125];
    [meter_view setMinScale2:-55];
    [self updateStateSW1:FALSE SW2:FALSE SW3:FALSE SW4:FALSE];
    led = 0xFF;
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction) setVolumeFromFloat:(id)sender
{
    volume = [(UISlider *)sender value];
}

- (IBAction) graph_temperature:(float) temp andPot:(float) pot
{
    // configure the graph view for the temperature sensor
    [graph_view addData:pot andData:temp];
}

- (IBAction) meter_temperature:(float) temp andPot:(float) pot
{
    // configure the meter view for the temperature sensor
    [meter_view addData:pot andData:temp];
}

- (IBAction) updateLED:(id) sender
{
	if([(UISwitch *)sender isOn])
	{
		led |= 0x01 << [(UISwitch *)sender tag];
	}
	else
	{
		led &= ~(0x01 << [(UISwitch *)sender tag]);
	}
}

- (IBAction) updateStateSW1:(BOOL)a SW2:(BOOL)b SW3:(BOOL)c SW4:(BOOL)d
{
    UIColor *red   = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    UIColor *green = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    if(a)
    {
        [sw1 setTextColor:green];
        [sw1 setText:@"SW1 Pressed"];        
    }
    else
    {
        [sw1 setTextColor:red];
        [sw1 setText:@"SW1 Released"];
    }
    if(b)
    {
        [sw2 setTextColor:green];
        [sw2 setText:@"SW2 Pressed"];        
    }
    else
    {
        [sw2 setTextColor:red];
        [sw2 setText:@"SW2 Released"];
    }
    if(c)
    {
        [sw3 setTextColor:green];
        [sw3 setText:@"SW3 Pressed"];        
    }
    else
    {
        [sw3 setTextColor:red];
        [sw3 setText:@"SW3 Released"];
    }
    if(d)
    {
        [sw4 setTextColor:green];
        [sw4 setText:@"SW4 Pressed"];        
    }
    else
    {
        [sw4 setTextColor:red];
        [sw4 setText:@"SW4 Released"];
    }
    
}

- (IBAction)  updateInfoName:(NSString *) name
                manufacturer:(NSString *) man
                 modelNumber:(NSString *) mn      
                serialNumber:(NSString *) sn
            firmwareRevision:(NSString *) fr  
            hardwareRevision:(NSString *) hr
			 BoardIdentifier:(NSString *)boardStr
				  updateRate:(NSString *)updateStr;
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"Name : "];
    
    [str appendString:name];
    [str appendString:@"\nManufacturer : "];
    [str appendString:man];
    [str appendString:@"\nModel # : "];
    [str appendString:mn];
    [str appendString:@"\nSerial # : "];
    [str appendString:sn];
    [str appendString:@"\nFW Revision : "];
    [str appendString:fr];
    [str appendString:@"\nHW Revision : "];
    [str appendString:hr];
    [str appendString:@"\nBoard Name : "];
    [str appendString:boardStr];
    [str appendString:@"\nData Request Rate : "];
    [str appendString:updateStr];

    
    [infoLabel setText:str];
    [str release];
}

@end
