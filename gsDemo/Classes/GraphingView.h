    //  GraphingView.h
    //  MCHP MFI
    //
    //  Created by jjulicher on 8/28/09.
    //  Copyright Microchip Technology Inc. 2009. All rights reserved.
    //
    //


#import <UIKit/UIKit.h>

struct graphData_s
{
    float   data1;
    float   data2;
    
};

// Constant for the number of data samples kept in history.
#define kHistorySize 150

// GraphView class interface.

@interface GraphingView : UIView 
{
    NSUInteger nextIndex;

    struct graphData_s data[kHistorySize];
    BOOL updatingIsEnabled;

    float   maxScale1;
    float   maxScale2;
    float   minScale1;
    float   minScale2;
    
}

@property float maxScale1;
@property float maxScale2;
@property float minScale1;
@property float minScale2;
@property BOOL updatingIsEnabled;

// Add data to the history.
- (void)addData:(float)d1 andData:(float)d2;

@end
