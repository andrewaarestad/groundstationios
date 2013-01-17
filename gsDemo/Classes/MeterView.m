//
//  MeterView.m
//  MCHP MFI
//
//  Created by Joseph Julicher on 8/31/09.
//  Copyright Microchip Technology Inc. 2009 All rights reserved.
//

#import "MeterView.h"


@implementation MeterView

#define kPi 3.141592654
#define kStartAngle     (-kPi/4)
#define kFinishAngle    (kStartAngle - (kPi/2))

@synthesize maxScale1;
@synthesize maxScale2;
@synthesize minScale1;
@synthesize minScale2;

CGPoint angleToPoint(float a, float radius, CGPoint center);
float valueToAngle(float value, float max, float min);

- (void)drawRect:(CGRect)clip 
{
    UIFont *font;
    CGSize size = [self bounds].size;
    CGPoint pivot;
    CGContextRef context = UIGraphicsGetCurrentContext();
    float needleRadius, scaleRadius, i, a, pivotRadius;
    CGSize s1, s2;
    CGPoint n1,n2,n3;
    
    //CGContextSetAllowsAntialiasing(context, false);
    CGRect hBounds = CGRectMake(0, 0, size.width, size.height);

    font = [UIFont systemFontOfSize:hBounds.size.height*0.10];
    needleRadius = (0.60 * hBounds.size.height); // needle radius is 60%
    scaleRadius = (0.60 * hBounds.size.height); // scale radius is 60%
    pivotRadius = (0.05 * hBounds.size.height); // scale pivot radius 5%
    
    pivot.x = hBounds.origin.x+hBounds.size.width/2;
    pivot.y = hBounds.origin.y+hBounds.size.height/2 + scaleRadius/2;

    CGContextSetLineWidth(context,hBounds.size.width*0.015);

    /*
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextBeginPath(context);
    CGContextAddRect(context,hBounds);
    CGContextFillPath(context);
    */
    
    // draw the bezel
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    hBounds.origin.x+hBounds.size.width/2,
                    hBounds.origin.y+hBounds.size.height/2,
                    (hBounds.size.width/2)-1,
                    0,2*kPi,
                    0);
    CGContextSetLineWidth(context,2);
    CGContextStrokePath(context);

    // create the clipping path
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    hBounds.origin.x+hBounds.size.width/2,
                    hBounds.origin.y+hBounds.size.height/2,
                    (hBounds.size.width/2)-1,
                    0,2*kPi,
                    0);
    CGContextClip(context);
    
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    hBounds.origin.x+hBounds.size.width/2,
                    hBounds.origin.y+hBounds.size.height/2,
                    (hBounds.size.width/2)-1,
                    0,2*kPi,
                    0);
    CGContextFillPath(context);

    // draw the first scale
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    pivot.x,
                    pivot.y,
                    scaleRadius,
                    kStartAngle,kFinishAngle,
                    1);
    CGContextStrokePath(context);
    // tick marks
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
    for( i=kFinishAngle;i<kStartAngle;i+=(kStartAngle-kFinishAngle)/10)
    {
        n1.x = pivot.x + (scaleRadius-5) * cos(i);
        n1.y = pivot.y + (scaleRadius-5) * sin(i);
        n2.x = pivot.x + (scaleRadius+5) * cos(i);
        n2.y = pivot.y + (scaleRadius+5) * sin(i);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context,n1.x,n1.y);
        CGContextAddLineToPoint(context,n2.x,n2.y);
        CGContextStrokePath(context);
    }
    

    s1 = [[NSString stringWithFormat:@"%0.1f", d1] sizeWithFont:font];
    s2 = [[NSString stringWithFormat:@"%0.1f", d2] sizeWithFont:font];
    n1.x = hBounds.origin.x + hBounds.size.width/2 - hBounds.size.width/4 - s1.width/2;
    n1.y = hBounds.origin.y + hBounds.size.height - hBounds.size.height/3;
    n2.y = n1.y;
    n2.x = hBounds.origin.x + hBounds.size.width/2 + hBounds.size.width/4 - s2.width/2;
    CGContextSetRGBFillColor(context, 0, 1, 0, 1.0);
    CGContextBeginPath(context);
    [[NSString stringWithFormat:@"%0.1f", d1] drawAtPoint:n1 withFont:font]; 
    CGContextStrokePath(context);    
    CGContextSetRGBFillColor(context, 1, 0, 0, 1.0);
    CGContextBeginPath(context);
    [[NSString stringWithFormat:@"%0.1f", d2] drawAtPoint:n2 withFont:font]; 
    CGContextStrokePath(context);

        
    // draw the first needle
    // minscale1 = start angle while maxscale1 = finishangle
    a = valueToAngle(d2,maxScale2,minScale2);
    CGContextSetRGBFillColor(context,1,0,0,.75);
    CGContextSetRGBStrokeColor(context,1,0,0,1);
    n1 = angleToPoint(a,needleRadius,pivot);// tip
    n2 = angleToPoint(a+kPi/2,pivotRadius,pivot); // wing
    n3 = angleToPoint(a-kPi/2,pivotRadius,pivot); // wing
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,pivot.x,pivot.y);
    CGContextAddLineToPoint(context,n2.x,n2.y);
    CGContextAddLineToPoint(context,n1.x,n1.y);
    CGContextAddLineToPoint(context,n3.x,n3.y);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    // draw the second needle
    a = valueToAngle(d1,maxScale1,minScale1);
    CGContextSetRGBFillColor(context,0,1,0,.75);
    CGContextSetRGBStrokeColor(context,0,1,0,1);
    n1 = angleToPoint(a,needleRadius,pivot);// tip
    n2 = angleToPoint(a+kPi/2,pivotRadius,pivot); // wing
    n3 = angleToPoint(a-kPi/2,pivotRadius,pivot); // wing
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,pivot.x,pivot.y);
    CGContextAddLineToPoint(context,n2.x,n2.y);
    CGContextAddLineToPoint(context,n1.x,n1.y);
    CGContextAddLineToPoint(context,n3.x,n3.y);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    // draw the pivot
    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    hBounds.origin.x+hBounds.size.width/2,
                    hBounds.origin.y+hBounds.size.height,
                    (hBounds.size.width/4)-1,
                    0,kPi,
                    1);
    CGContextFillPath(context);
    
    //CGContextSetAllowsAntialiasing(context, true);
}

// Add data to the history.
- (void)addData:(float)a andData:(float)b
{
    if(a > maxScale1) a = maxScale1;
    if(a < minScale1) a = minScale1;
    if(b > maxScale2) b = maxScale2;
    if(b < minScale2) b = minScale2;
    d1 = a;
    d2 = b;
    [self setNeedsDisplay];
}

CGPoint angleToPoint(float a, float radius, CGPoint center)
{
    CGPoint ret;
    ret.x = center.x + radius * cos(a);
    ret.y = center.y + radius * sin(a);
    return ret;    
}

float valueToAngle(float value, float max, float min)
{
    float a;
    a = value - min;
    a *= (kStartAngle - kFinishAngle)/(max-min);
    a += kFinishAngle;
    return a;
}

@end
