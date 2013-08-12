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

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                          renderer:(THZUICanvasViewRenderer*)renderer;
{
    self = [super init];
    if (self)
    {
        self.scrollView = scrollView;
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
    UIView* canvasView = [self.scrollView.subviews firstObject];
    CGRect rect = [canvasView convertRect:elementView.frame fromView:elementView.superview];
    [self.scrollView zoomToRect:rect animated:YES];
}

- (void)handleElementViewLongPressGesture:(UILongPressGestureRecognizer*)recognizer
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element.parentElement bringChildElementToFront:elementView.element])
        [self.renderer renderElement:elementView.element];
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
