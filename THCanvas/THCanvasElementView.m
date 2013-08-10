//
//  THCanvasElementView.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasElementView.h"
#import "THCanvasElement.h"

@interface THCanvasElementView () <UIGestureRecognizerDelegate>

@end

@implementation THCanvasElementView

- (id)init
{
    NSAssert(NO, @"use initWithElement:gestureHandler:");
    return nil;
}

- (instancetype)initWithElement:(THCanvasElement*)element
                 gestureHandler:(id<THCanvasElementGestureHandler>)gestureHandler
{
    NSParameterAssert(element && gestureHandler);
    
    self = [super init];
    if (self)
    {
        self.element = element;
        self.gestureHandler = gestureHandler;
        
        UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewPanGesture:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        UIRotationGestureRecognizer* rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewRotationGesture:)];
        rotationGestureRecognizer.delegate = self;
//        [self addGestureRecognizer:rotationGestureRecognizer];
        
        UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewPinchGesture:)];
        pinchGestureRecognizer.delegate = self;
//        [self addGestureRecognizer:pinchGestureRecognizer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Properties

- (void)setElement:(THCanvasElement *)element
{
    if (self.element == element) return;
    
    _element = element;
    
    [self update];
}

#pragma mark - Public Methods

- (void)update
{
    if (! self.element) return;
    
    self.frame = self.element.frame;
    self.backgroundColor = self.element.backgroundColor;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // can only interact with one element at a time
    return (gestureRecognizer.view == otherGestureRecognizer.view);
}

@end
