//
//  MCHP_MFIViewController.h
//  MCHP MFI
//
//  Created by Joseph Julicher on 8/28/09.
//  Copyright Microchip Technology Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphingView.h"
#import "MeterView.h"

@interface MCHP_MFIViewController : UIViewController {

    IBOutlet GraphingView *graph_view;
    IBOutlet MeterView *meter_view;
    IBOutlet UILabel *sw1;
    IBOutlet UILabel *sw2;
    IBOutlet UILabel *sw3;
    IBOutlet UILabel *sw4;
	IBOutlet UISlider *volumeSlider;
    IBOutlet UILabel *infoLabel;
    
	SEL volumeUpdater;
	SEL ledUpdater;
	
	float volume;
    uint8_t led;
}
@property SEL ledUpdater;
@property SEL volumeUpdater;
@property(nonatomic) float volume;
@property(nonatomic) uint8_t led;

- (IBAction) updateLED:(id)sender;

- (IBAction) updateStateSW1:(BOOL)a SW2:(BOOL)b SW3:(BOOL)c SW4:(BOOL)d;

- (IBAction) setVolumeFromFloat:(id)sender;
- (IBAction) graph_temperature:(float) temp andPot:(float) pot;
- (IBAction) meter_temperature:(float) temp andPot:(float) pot;

- (IBAction)  updateInfoName:(NSString *) name
                manufacturer:(NSString *) man
                 modelNumber:(NSString *) mn      
                serialNumber:(NSString *) sn
            firmwareRevision:(NSString *) fr  
            hardwareRevision:(NSString *) hr
			 BoardIdentifier:(NSString *)boardStr
				  updateRate:(NSString *)updateStr;


@end

