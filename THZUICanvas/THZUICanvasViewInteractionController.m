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

@interface THZUICanvasViewInteractionController ()

@property (nonatomic, strong) NSTimer* autoScrollingTimer;
@property (nonatomic, assign) CGPoint autoScrolling;

@end

@implementation THZUICanvasViewInteractionController

#define AUTO_SCROLL_EDGE_WIDTH 50
#define AUTO_SCROLL_IVAL .01
#define AUTO_SCROLL_STEP 7

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

#define THMovingCanvasElementKey @"THMovingCanvasElementKey"

- (void)handleElementViewPanGesture:(UIPanGestureRecognizer*)recognizer
{
    THZUICanvasElementView* elementView = (THZUICanvasElementView*)recognizer.view;
    [self.renderer selectElementView:elementView];
    if ([elementView.element translate:[recognizer translationInView:elementView]])
        [self.renderer renderElement:elementView.element];
    [recognizer setTranslation:CGPointZero inView:elementView];
    
    if (recognizer.state != UIGestureRecognizerStateBegan
        && recognizer.state != UIGestureRecognizerStateChanged)
    {
        // end auto scrolling
        [self.autoScrollingTimer invalidate];
        self.autoScrollingTimer = nil;
        return;
    }

    // determine auto scrolling
    CGPoint locationInScrollview = [recognizer locationInView:self.renderer.canvasView];
    locationInScrollview.x -= self.scrollView.contentOffset.x;
    locationInScrollview.y -= self.scrollView.contentOffset.y;
    CGPoint autoScroll = CGPointZero;
    if (locationInScrollview.x < AUTO_SCROLL_EDGE_WIDTH)
        autoScroll.x = -AUTO_SCROLL_STEP;
    else if (locationInScrollview.x > self.scrollView.frame.size.width - AUTO_SCROLL_EDGE_WIDTH)
        autoScroll.x = AUTO_SCROLL_STEP;
    if (locationInScrollview.y < AUTO_SCROLL_EDGE_WIDTH)
        autoScroll.y = -AUTO_SCROLL_STEP;
    else if (locationInScrollview.y > self.scrollView.frame.size.height - AUTO_SCROLL_EDGE_WIDTH)
        autoScroll.y = AUTO_SCROLL_STEP;
    self.autoScrolling = autoScroll;
    
    if (CGPointEqualToPoint(CGPointZero, self.autoScrolling)
        || self.autoScrollingTimer) return;
    
    // setup auto scrolling timer
    self.autoScrollingTimer = [NSTimer timerWithTimeInterval:AUTO_SCROLL_IVAL target:self
                                                    selector:@selector(autoScroll:)
                                                    userInfo:@{ THMovingCanvasElementKey : elementView.element }
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.autoScrollingTimer forMode:NSDefaultRunLoopMode];
}

- (void)autoScroll:(NSTimer*)timer
{
    if (CGPointEqualToPoint(CGPointZero, self.autoScrolling))
    {
        // end auto scrolling
        [self.autoScrollingTimer invalidate];
        self.autoScrollingTimer = nil;
        return;
    }
    
    // calculate new offset
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGPoint newContentOffset = (CGPoint) {
        .x = MIN(MAX(0, contentOffset.x + self.autoScrolling.x),
                 self.scrollView.contentSize.width - self.scrollView.bounds.size.width),
        .y = MIN(MAX(0, contentOffset.y + self.autoScrolling.y),
                 self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
    };
    
    // translate element view
    CGPoint translation = (CGPoint) {
        .x = newContentOffset.x - contentOffset.x,
        .y = newContentOffset.y - contentOffset.y
    };
    THZUICanvasElement* element = timer.userInfo[THMovingCanvasElementKey];
    CGPoint oldCenter = element.center;
    if (! [element translate:translation]) return;
    [self.renderer renderElement:element];
    
    // re-calculate new offset based on the actual element translation
    newContentOffset = (CGPoint) {
        .x = MIN(MAX(0, contentOffset.x + element.center.x - oldCenter.x),
                 self.scrollView.contentSize.width - self.scrollView.bounds.size.width),
        .y = MIN(MAX(0, contentOffset.y + element.center.y - oldCenter.y),
                 self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
    };
    
    // adjust content offset
    [self.scrollView setContentOffset:newContentOffset animated:NO];
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
