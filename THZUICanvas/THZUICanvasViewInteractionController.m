//
//  THZUICanvasViewInteractionController.m
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasViewInteractionController.h"
#import "THZUICanvasElementView.h"
#import "THZUICanvasElement.h"
#import "THZUICanvasViewRenderer.h"

@implementation THZUICanvasViewInteractionController

- (instancetype)initWithRenderer:(THZUICanvasViewRenderer*)renderer
{
    self = [super init];
    if (self)
    {
        self.renderer = renderer;
    }
    return self;
}

#pragma mark - THZUICanvasElementGestureHandler

- (void)handleElementViewSingleTapGesture:(UITapGestureRecognizer*)recognizer
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
}

- (void)handleElementViewDoubleTapGesture:(UITapGestureRecognizer*)recognizer
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    // TODO: zoom to element
}

- (void)handleElementViewPanGesture:(UIPanGestureRecognizer*)recognizer
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element translate:[recognizer translationInView:elementView]])
        [self.renderer renderElement:elementView.element];
    [recognizer setTranslation:CGPointZero inView:elementView];
}

- (void)handleElementViewRotationGesture:(UIRotationGestureRecognizer*)recognizer;
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element rotate:recognizer.rotation])
        [self.renderer renderElement:elementView.element];
    recognizer.rotation = 0;
}

- (void)handleElementViewPinchGesture:(UIPinchGestureRecognizer*)recognizer
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element scale:recognizer.scale])
        [self.renderer renderElement:elementView.element];
    recognizer.scale = 1;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return ([gestureRecognizer.view isKindOfClass:[THZUICanvasElementView class]]);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // can only interact with one element at a time
    return (gestureRecognizer.view == otherGestureRecognizer.view);
}

@end
