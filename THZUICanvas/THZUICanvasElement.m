//
//  THZUICanvasElement.m
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasElement.h"
#import "THZUICanvasElementView.h"

@interface THZUICanvasElement ()

@property (nonatomic, strong) NSMutableOrderedSet* mutableChildElements;
@property (nonatomic, readonly, assign) CGRect childElementsUnionFrame;

@end

@implementation THZUICanvasElement

- (id)init
{
    NSAssert(NO, @"use initWithDataSource:");
    return nil;
}

- (instancetype)initWithDataSource:(id<THZUICanvasElementDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    
    self = [super init];
    if (self)
    {
        self.dataSource = dataSource;
        self.frame = (CGRect) {
            .origin = CGPointZero,
            .size = self.dataSource.canvasElementMinSize
        };
        self.rotation = 0;
        self.modifiable = YES;
        self.mutableChildElements = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

#pragma mark - Properties

- (Class)viewClass
{
    return [THZUICanvasElementView class];
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectEqualToRect(self.frame, frame)) return;
    
    frame = (CGRect) {
        .origin = frame.origin,
        .size.width = MAX(self.dataSource.canvasElementMinSize.width, frame.size.width),
        .size.height = MAX(self.dataSource.canvasElementMinSize.width, frame.size.height)
    };
    
    if ([self frameIsWithinParentElementBoundsAndContainsAllChildElementFrames:frame])
        _frame = frame;
}

- (CGPoint)center
{
    return (CGPoint) { .x = CGRectGetMidX(self.frame), .y = CGRectGetMidY(self.frame) };
}

- (CGRect)bounds
{
    return (CGRect) { .size = self.frame.size };
}

- (void)setRotation:(CGFloat)rotation
{
    // normalize
    while (rotation >= 2 * M_PI) rotation -= 2 * M_PI;
	while (rotation < 0) rotation += 2 * M_PI;
    
    if (self.rotation == rotation) return;
    
    _rotation = rotation;
}

- (NSOrderedSet*)childElements
{
    return self.mutableChildElements;
}

- (CGRect)childElementsUnionFrame
{
    CGRect unionFrame = CGRectNull;
    for (THZUICanvasElement* childElement in self.childElements)
        unionFrame = CGRectUnion(unionFrame, childElement.frame);
    return unionFrame;
}

#pragma mark - Public Methods

- (void)addChildElement:(THZUICanvasElement*)childElement
{
    NSParameterAssert(childElement);
    
    [self.mutableChildElements addObject:childElement];
    childElement.parentElement = self;
}

- (void)removeChildElement:(THZUICanvasElement*)childElement
{
    NSParameterAssert(childElement);
    
    [self.mutableChildElements removeObject:childElement];
    childElement.parentElement = nil;
}

- (BOOL)translate:(CGPoint)translation
{
    if (! self.modifiable) return NO;
    
    CGAffineTransform t = CGAffineTransformMakeRotation(-self.rotation);
    t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(translation.x,
                                                                    translation.y));
    t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(self.rotation));
    CGRect newFrame = CGRectApplyAffineTransform(self.frame, t);
    
    CGRect oldFrame = self.frame;
    self.frame = newFrame;
    
    return (! CGRectEqualToRect(oldFrame, self.frame));
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
    
    if (newSize.width < self.dataSource.canvasElementMinSize.width
        || newSize.height < self.dataSource.canvasElementMinSize.height) return NO;

    CGRect newFrame = CGRectInset(self.frame,
                                  (self.frame.size.width - newSize.width) / 2,
                                  (self.frame.size.height - newSize.height) / 2);
    
    CGRect oldFrame = self.frame;
    self.frame = newFrame;
    
    return (! CGRectEqualToRect(oldFrame, self.frame));
}

#pragma mark - Util

- (BOOL)frameIsWithinParentElementBoundsAndContainsAllChildElementFrames:(CGRect)frame
{
    BOOL isWithinParentElementBounds = (! self.parentElement
                                        || CGRectContainsRect(self.parentElement.bounds, frame));
    CGRect bounds = (CGRect) { .size = frame.size };
    BOOL containsAllChildElementFrames = CGRectContainsRect(bounds, self.childElementsUnionFrame);
    return (isWithinParentElementBounds && containsAllChildElementFrames);
}

@end
