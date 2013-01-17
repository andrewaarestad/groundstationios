 //  GraphingView.m
 //  MCHP MFI
 //
 //  Created by jjulicher on 8/28/09.
 //  Copyright Microchip Technology Inc. 2009. All rights reserved.
 //
 //

#import "GraphingView.h"

// GraphView class implementation.
@implementation GraphingView

// Instruct the compiler to generate accessors for the property, and use the internal variable _filter for storage.
@synthesize updatingIsEnabled;
@synthesize maxScale1;
@synthesize maxScale2;
@synthesize minScale1;
@synthesize minScale2;

float valueToY(float value,float max,float min,CGRect bounds);

- (void)addData:(float)d1 andData:(float)d2
{
    data[nextIndex].data1 = d1;
    data[nextIndex].data2 = d2;
    nextIndex = (nextIndex + 1) % kHistorySize;
    
   [self setNeedsDisplay];
}

- (void)drawData:(unsigned)index inContext:(CGContextRef)context bounds:(CGRect)bounds {
    UIFont *font = [UIFont systemFontOfSize:12];
    unsigned i;
    int value;
    float textHeight, textWidth;
    CGRect bbox;
    
    
    // Draw the background
    CGContextSetGrayFillColor(context, 0, 1.0); // black
    CGContextFillRect(context, bounds);

    textHeight = 16;
    textWidth = 55; // make up a number

    bbox.origin.y = bounds.origin.y + textHeight/2;
    bbox.origin.x = bounds.origin.x + textWidth;
    bbox.size.height = bounds.size.height - textHeight;
    bbox.size.width = bounds.size.width - textWidth;
    
    CGContextSetGrayFillColor(context, 0.1, 1.0); // a little grey
    CGContextFillRect(context, bbox);
    
    // Draw the intermediate lines
    CGContextSetRGBStrokeColor(context, 0, 0.5, 0, 1.0);
    CGContextBeginPath(context);
    for (value = minScale1; value <= maxScale1; value += (maxScale1-minScale1)/4)
    {
        float y = valueToY(value,maxScale1,minScale1,bbox);
        CGContextMoveToPoint(context, bbox.origin.x, y);
        CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, y);
    }
    CGContextStrokePath(context);
            
    // Draw the data lines

    CGContextSetRGBStrokeColor(context, 0.25, 1, 0.25, 1.0);
    CGContextBeginPath(context);
    for (i = 0; i < kHistorySize; ++i)
    {
        float x = bbox.origin.x + (float)i / (float)(kHistorySize - 1) * bbox.size.width;
        // NOTE: We need to draw upside-down as UIView referential has the Y axis going down
        // scales by drawing short lines between points so they all fit on the width of the control
        float v = valueToY(data[(index + i) % kHistorySize].data1,maxScale1,minScale1,bbox);
        if (i > 0)
        {
            CGContextAddLineToPoint(context, x, v);
        }
        else
        {
            CGContextMoveToPoint(context, x, v);
        }
    }
	CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);

    CGContextSetRGBStrokeColor(context, 1, 0.25, 0.25, 1.0);
    CGContextBeginPath(context);
    for (i = 0; i < kHistorySize; ++i)
    {
        float x = bbox.origin.x + (float)i / (float)(kHistorySize - 1) * bbox.size.width;
        // NOTE: We need to draw upside-down as UIView referential has the Y axis going down
        // scales by drawing short lines between points so they all fit on the width of the control
        float v = valueToY(data[(index + i) % kHistorySize].data2,maxScale2,minScale2,bbox);
        if (i > 0)
        {
            CGContextAddLineToPoint(context, x, v);
        }
        else
        {
            CGContextMoveToPoint(context, x, v);
        }
    }
	CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 0.25, 1, 0.25, 1.0);
    CGContextBeginPath(context);
    for (i = 0; i < kHistorySize; ++i)
    {
    }
	CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
	CGContextSetLineWidth(context, 1.0);
    
    // Draw the labels with AA on
    CGContextSetRGBFillColor(context, 0.12, 0.50, 0.12, 1.0);
    CGContextSetAllowsAntialiasing(context, true);
    for (value = minScale1; value <= maxScale1; value += (maxScale1-minScale1)/4)
    {
        float y = valueToY(value,maxScale1,minScale1,bbox)-textHeight/2;
    // NOTE: We need to draw upside-down as UIView referential has the Y axis going down
        [[NSString stringWithFormat:@"%d", value]
         drawAtPoint:CGPointMake(bounds.origin.x + 4,  y) withFont:font]; 
    }
    CGContextSetRGBFillColor(context, 0.75, 0.12, 0.12, 1.0);
    for (value = minScale2; value <= maxScale2; value += (maxScale2-minScale2)/4)
    {
        float y = valueToY(value,maxScale2,minScale2,bbox)-textHeight/2;
        // NOTE: We need to draw upside-down as UIView referential has the Y axis going down
        [[NSString stringWithFormat:@"%d", value]
         drawAtPoint:CGPointMake(bounds.origin.x + 35,  y) withFont:font]; 
    }
    
    CGContextSetAllowsAntialiasing(context, false);

    // blue outline
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,bounds.origin.x,bounds.origin.y+1);
    CGContextAddLineToPoint(context,bounds.size.width-1,bounds.origin.y+1);
    CGContextAddLineToPoint(context,bounds.size.width-1,bounds.size.height);
    CGContextAddLineToPoint(context,bounds.origin.x+1,bounds.size.height);
    CGContextAddLineToPoint(context,bounds.origin.x,bounds.origin.y+1);
    CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);    
    CGContextStrokePath(context);
    
}

- (void)drawRect:(CGRect)clip {
    CGSize size = [self bounds].size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    unsigned index = nextIndex;
    
    CGContextSetAllowsAntialiasing(context, false);
    CGRect hBounds = CGRectMake(0, 0, size.width, size.height);
    [self drawData:index inContext:context bounds:hBounds];
    CGContextSetAllowsAntialiasing(context, true);
}

float valueToY(float value,float max,float min,CGRect bounds)
{
    // step 1 saturate
    if(value > max) value = max;
    if(value < min) value = min;
    
    // step 2 data offset
    value -= min;
    
    // step 3 scale
    value *= (bounds.size.height)/(max - min);
    
    // step 4 result offset
    value = bounds.size.height - value;
    value += bounds.origin.y;

    return value;
}

@end
