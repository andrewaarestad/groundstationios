//
//  MCHP_MFIAppDelegate.h
//  MCHP MFI
//
//  Created by jjulicher on 8/28/09.
//  Copyright Microchip Technology Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExternalAccessory/ExternalAccessory.h"
#import "splashView.h"
#import "protocolDemo1.h"

@class MCHP_MFIViewController;

@interface MCHP_MFIAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate> {
    UIWindow *window;
    MCHP_MFIViewController *viewController;

	protocolDemo1 *demo;
	
    NSMutableData *data;
    BOOL streamReady;
    
	UIAlertView *alertView;
    splashView *theSplashView;
	
	NSTimer *updateTimer;
        
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MCHP_MFIViewController *viewController;

@end

