//
//  MeterView.h
//  MCHP MFI
//
//  Created by Joseph Julicher on 8/31/09.
//  Copyright Microchip Technology Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeterView : UIView
{
    float   d1;
    float   d2;
    float   maxScale1;
    float   maxScale2;
    float   minScale1;
    float   minScale2;    
}

@property float maxScale1;
@property float maxScale2;
@property float minScale1;
@property float minScale2;

- (void)addData:(float)a andData:(float)b;

@end
