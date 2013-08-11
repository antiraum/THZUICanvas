//
//  THCanvasElementView.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasElementView.h"
#import "THCanvasElement.h"

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
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor blueColor] CGColor];
        
        self.element = element;
        self.gestureHandler = gestureHandler;
        
        if (self.element.modifiable)
        {
            UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewSingleTapGesture:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            singleTapGestureRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:singleTapGestureRecognizer];
            
            UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewDoubleTapGesture:)];
            doubleTapGestureRecognizer.numberOfTapsRequired = 2;
            doubleTapGestureRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:doubleTapGestureRecognizer];
            
            UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewPanGesture:)];
            panGestureRecognizer.maximumNumberOfTouches = 1;
            panGestureRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:panGestureRecognizer];
            
            UIRotationGestureRecognizer* rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewRotationGesture:)];
            rotationGestureRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:rotationGestureRecognizer];
            
            UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self.gestureHandler action:@selector(handleElementViewPinchGesture:)];
            pinchGestureRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:pinchGestureRecognizer];
        }
    }
    return self;
}

#pragma mark - Properties

- (void)setElement:(THCanvasElement *)element
{
    if (self.element == element) return;
    
    _element = element;
    
    [self update];
}

- (void)setSelected:(BOOL)selected
{
    if (self.selected == selected) return;
    
    _selected = selected;
    
    self.layer.borderWidth = (selected) ? 4 : 0;
}

#pragma mark - Public Methods

- (void)update
{
    if (! self.element) return;
    
    self.transform = CGAffineTransformIdentity;
    self.frame = self.element.frame;
    if (self.element.rotation != 0)
        self.transform = CGAffineTransformMakeRotation(self.element.rotation);
}

@end
