//
//  THCanvasViewInteractionController.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasViewInteractionController.h"
#import "THCanvasElementView.h"
#import "THCanvasElement.h"
#import "THCanvasViewRenderer.h"

@implementation THCanvasViewInteractionController

- (instancetype)initWithRenderer:(THCanvasViewRenderer*)renderer
{
    self = [super init];
    if (self)
    {
        self.renderer = renderer;
    }
    return self;
}

#pragma mark - THCanvasElementGestureHandler

- (void)handleElementViewSingleTapGesture:(UITapGestureRecognizer*)recognizer
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
}

- (void)handleElementViewDoubleTapGesture:(UITapGestureRecognizer*)recognizer
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    // TODO: zoom to element
}

- (void)handleElementViewPanGesture:(UIPanGestureRecognizer*)recognizer
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element translate:[recognizer translationInView:elementView]])
        [self.renderer renderElement:elementView.element];
    [recognizer setTranslation:CGPointZero inView:elementView];
}

- (void)handleElementViewRotationGesture:(UIRotationGestureRecognizer*)recognizer;
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element rotate:recognizer.rotation])
        [self.renderer renderElement:elementView.element];
    recognizer.rotation = 0;
}

- (void)handleElementViewPinchGesture:(UIPinchGestureRecognizer*)recognizer
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element scale:recognizer.scale])
        [self.renderer renderElement:elementView.element];
    recognizer.scale = 1;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return ([gestureRecognizer.view isKindOfClass:[THCanvasElementView class]]);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // can only interact with one element at a time
    return (gestureRecognizer.view == otherGestureRecognizer.view);
}

@end
