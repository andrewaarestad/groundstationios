//
//  splashView.h
//  MCHP MFI
//
//  Created by Joseph Julicher on 4/12/10.
//  Copyright 2010 Microchip Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface splashView : UIView {
    UIImageView *splashView;
    UIImage *splashImg;
    UIImage *splashLogo;
    NSArray *textArray;
}
- (void)viewUpdate:(NSTimer*)theTimer;

@end
