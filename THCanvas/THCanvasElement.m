//
//  THCanvasElement.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasElement.h"

@implementation THCanvasElement

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor
{
    self = [super init];
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = backgroundColor;
        self.childElements = [NSMutableSet set];
    }
    return self;
}

- (void)addChildElement:(THCanvasElement*)childElement
{
    NSParameterAssert(childElement);
    
    [self.childElements addObject:childElement];
    childElement.parentElement = self;
}

- (void)translate:(CGPoint)translation
{
    // TODO: keep within parent element bounds
    self.frame = CGRectApplyAffineTransform(self.frame, CGAffineTransformMakeTranslation(translation.x, translation.y));
}

- (void)rotate:(CGFloat)rotation
{
    self.frame = CGRectApplyAffineTransform(self.frame, CGAffineTransformMakeRotation(rotation));
}

- (void)scale:(CGFloat)scale
{
    self.frame = CGRectApplyAffineTransform(self.frame, CGAffineTransformMakeScale(scale, scale));
}

@end
