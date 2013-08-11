//
//  THCanvasElement.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasElement.h"

@interface THCanvasElement ()

@property (nonatomic, readonly, assign) CGFloat minSize;
@property (nonatomic, readonly, assign) CGRect childElementsUnionFrame;

@end

@implementation THCanvasElement

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor
{
    self = [super init];
    if (self)
    {
        self.modifiable = YES;
        self.frame = frame;
        self.rotation = 0;
        self.backgroundColor = backgroundColor;
        self.childElements = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Properties

- (void)setFrame:(CGRect)frame
{
    if (CGRectEqualToRect(self.frame, frame)) return;
    
    _frame = (CGRect) {
        .origin = frame.origin,
        .size.width = MAX(self.minSize, frame.size.width),
        .size.height = MAX(self.minSize, frame.size.height)
    };
}

- (CGPoint)center
{
    return (CGPoint) { .x = CGRectGetMidX(self.frame), .y = CGRectGetMidY(self.frame) };
}

- (CGRect)bounds
{
    return (CGRect) { .origin = CGPointZero, .size = self.frame.size };
}

- (void)setRotation:(CGFloat)rotation
{
    // normalize
    while (rotation >= 2 * M_PI) rotation -= 2 * M_PI;
	while (rotation < 0) rotation += 2 * M_PI;
    
    if (self.rotation == rotation) return;
    
    _rotation = rotation;
}

- (CGFloat)minSize
{
    return 10;
}

- (CGRect)childElementsUnionFrame
{
    CGRect unionFrame = CGRectNull;
    for (THCanvasElement* childElement in self.childElements)
        unionFrame = CGRectUnion(unionFrame, childElement.frame);
    return unionFrame;
}

#pragma mark - Public Methods

- (void)addChildElement:(THCanvasElement*)childElement
{
    NSParameterAssert(childElement);
    
    [self.childElements addObject:childElement];
    childElement.parentElement = self;
}

- (BOOL)translate:(CGPoint)translation
{
    if (! self.modifiable) return NO;
    
    CGAffineTransform t = CGAffineTransformMakeRotation(-self.rotation);
    t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(translation.x,
                                                                    translation.y));
    t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(self.rotation));
    CGRect frame = CGRectApplyAffineTransform(self.frame, t);
                                              
    if ([self frameIsWithinParentElementBoundsAndContainsAllChildElementFrames:frame])
    {
        self.frame = frame;
        return YES;
    }
    
    return NO;
}

- (BOOL)rotate:(CGFloat)rotation
{
    if (! self.modifiable) return NO;
    
    self.rotation += rotation;
    
    return (self.rotation != rotation);
}

- (BOOL)scale:(CGFloat)scale
{
    if (! self.modifiable) return NO;
    
    CGSize newSize = CGSizeApplyAffineTransform(self.frame.size,
                                                CGAffineTransformMakeScale(scale, scale));
    
    if (newSize.width < self.minSize || newSize.height < self.minSize) return NO;

    CGRect frame = CGRectInset(self.frame,
                               (self.frame.size.width - newSize.width) / 2,
                               (self.frame.size.height - newSize.height) / 2);
    
    if ([self frameIsWithinParentElementBoundsAndContainsAllChildElementFrames:frame])
    {
        self.frame = frame;
        return YES;
    }
    
    return NO;
}

#pragma mark - Util

- (BOOL)frameIsWithinParentElementBoundsAndContainsAllChildElementFrames:(CGRect)frame
{
    BOOL isWithinParentElementBounds = (! self.parentElement
                                        || CGRectContainsRect(self.parentElement.bounds, frame));
    CGRect bounds = (CGRect) { .origin = CGPointZero, .size = frame.size };
    BOOL containsAllChildElementFrames = CGRectContainsRect(bounds, self.childElementsUnionFrame);
    return (isWithinParentElementBounds && containsAllChildElementFrames);
}

@end
