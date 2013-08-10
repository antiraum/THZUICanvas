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

- (void)handleElementViewTapGesture:(UITapGestureRecognizer*)recognizer
{
//    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    // TODO
}

- (void)handleElementViewPanGesture:(UIPanGestureRecognizer*)recognizer
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    if (elementView.element.nonModifiable) return;
    [elementView.element translate:[recognizer translationInView:elementView]];
    [self.renderer renderElement:elementView.element];
    [recognizer setTranslation:CGPointZero inView:elementView];
}

- (void)handleElementViewRotationGesture:(UIRotationGestureRecognizer*)recognizer;
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    if (elementView.element.nonModifiable) return;
    [elementView.element rotate:recognizer.rotation];
    [self.renderer renderElement:elementView.element];
    recognizer.rotation = 0;
}

- (void)handleElementViewPinchGesture:(UIPinchGestureRecognizer*)recognizer
{
    THCanvasElementView* elementView = (THCanvasElementView*)recognizer.view;
    if (elementView.element.nonModifiable) return;
    if (isnan(recognizer.scale)) return;
    [elementView.element scale:recognizer.scale];
    [self.renderer renderElement:elementView.element];
    recognizer.scale = 0;
}

@end
