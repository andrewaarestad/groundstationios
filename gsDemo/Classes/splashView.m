//
//  splashView.m
//  MCHP MFI
//
//  Created by Joseph Julicher on 4/12/10.
//  Copyright 2010 Microchip Technology. All rights reserved.
//

#import "splashView.h"


@implementation splashView

- (void)viewUpdate:(NSTimer*)theTimer
{
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        splashImg = [UIImage imageNamed:@"MCHP_768x1024_iPad_noLogo.png"];
        splashLogo = [UIImage   imageNamed:@"MCHP_768x1024_iPad_LogoONLY.png"];
        [splashImg retain];
        [splashLogo retain];
        // initialize the text string array
        
        NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *stringsPath = [thisBundle pathForResource:@"strings" ofType:@"plist"];
        if (stringsPath )  {
            textArray = [[NSArray alloc] initWithContentsOfFile:stringsPath];
            [textArray retain];
        }
        
        
        [NSTimer scheduledTimerWithTimeInterval:3//secs
                                         target:self
                                       selector:@selector(viewUpdate:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIFont *font;
    CGRect bounds;
    CGRect textArea;
    bounds = [self bounds];
    
    font = [UIFont systemFontOfSize:bounds.size.height*0.05];

    bounds.size.height -= 16;
    
    [splashImg drawInRect:bounds];
    
    // draw messages

    textArea.origin.x = 0;
    textArea.size.width = bounds.size.width;
    textArea.size.height = bounds.size.height/3;
    textArea.origin.y = bounds.size.height - textArea.size.height;

    [[UIColor whiteColor] set];
    [[textArray objectAtIndex:(rand() % [textArray count])] drawInRect:textArea
                                           withFont:font
                                      lineBreakMode:UILineBreakModeWordWrap
                                          alignment:UITextAlignmentCenter];
    
    [splashLogo drawInRect:bounds];

}

- (void)dealloc {
    [super dealloc];
    [splashImg release];
    [splashLogo release];
    [textArray release];
}


@end
