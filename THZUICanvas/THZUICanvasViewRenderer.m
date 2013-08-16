//
//  THZUICanvasViewRenderer.m
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasViewRenderer.h"
#import "THZUICanvasElement.h"
#import "THZUICanvasElementView.h"

@interface THZUICanvasViewRenderer ()

@property (nonatomic, strong) NSCache* elementViewCache;
@property (nonatomic, weak) THZUICanvasElementView* rootElementView;
@property (nonatomic, strong) NSMutableArray* elementViewPool;

@end

@implementation THZUICanvasViewRenderer

- (id)init
{
    NSAssert(NO, @"use initWithView:rootElement:");
    return nil;
}

- (instancetype)initWithCanvasView:(UIView*)canvasView
                       rootElement:(THZUICanvasElement*)rootElement
         elementViewGestureHandler:(id<THZUICanvasElementGestureHandler>)elementViewGestureHandler
{
    NSParameterAssert(canvasView && rootElement);
    
    self = [super init];
    if (self)
    {
        self.elementViewCache = [[NSCache alloc] init];
        self.elementViewPool = [NSMutableArray array];
        self.elementViewGestureHandler = elementViewGestureHandler;
        self.canvasView = canvasView;
        self.rootElement = rootElement;
    }
    return self;
}

#pragma mark - Properties

- (void)setCanvasView:(UIView*)canvasView
{
    NSParameterAssert(canvasView);
    
    if (self.canvasView == canvasView) return;
    
    _canvasView = canvasView;
    
    if (self.rootElement)
        [self render];
}

- (void)setRootElement:(THZUICanvasElement *)rootElement
{
    NSParameterAssert(rootElement);
    
    if (self.rootElement == rootElement) return;
    
    _rootElement = rootElement;
    
    if (self.canvasView)
        [self render];
}

#pragma mark - Rendering

- (void)render
{
    [self renderElement:self.rootElement];
}

- (void)renderElement:(THZUICanvasElement*)element
{
    NSParameterAssert(element);
    
    NSAssert(element == self.rootElement || self.rootElementView,
             @"trying to render elment subtree before root element was rendered");
    
    if (! self.rootElementView) element = self.rootElement;
    
    NSUInteger index = (element.parentElement ?
                        [element.parentElement.childElements indexOfObject:element] : 0);
    [self renderElement:element inParentView:self.rootElementView atIndex:index];
}

- (void)renderElement:(THZUICanvasElement*)element
         inParentView:(THZUICanvasElementView*)parentElementView
              atIndex:(NSUInteger)index
{
    THZUICanvasElementView* elementView = nil;
    if (parentElementView)
        elementView = [self viewForElement:element inView:parentElementView];

    if (elementView)
    {
        [elementView update];
        
        UIView* superview = elementView.superview;
        if ([superview.subviews indexOfObject:elementView] != index) { // index has changed
            [elementView removeFromSuperview];
            [superview insertSubview:elementView atIndex:index];
        }
        
        // remove obsolete child element views
        for (UIView* subview in elementView.childElementContainerView.subviews)
            if ([subview isKindOfClass:[THZUICanvasElementView class]]
                && ! [element.childElements containsObject:[(THZUICanvasElementView*)subview element]])
                [self recycleElementView:(THZUICanvasElementView*)subview];
        
    } else {
        
        elementView = [self elementViewForElement:element];
        UIView* superview = (parentElementView ?
                             parentElementView.childElementContainerView : self.canvasView);
        [superview insertSubview:elementView atIndex:index];
    }
    
    [element.childElements enumerateObjectsUsingBlock:^(THZUICanvasElement* childElement, NSUInteger idx, BOOL *stop) {
        [self renderElement:childElement inParentView:elementView atIndex:idx];
    }];
}

- (void)recycleElementView:(THZUICanvasElementView*)elementView
{
    NSParameterAssert(elementView);
    
    if (elementView == self.rootElementView) self.rootElementView = nil;
    
    elementView.element = nil;
    [self.elementViewPool addObject:elementView];
    [elementView removeFromSuperview];
    
    for (UIView* subview in elementView.childElementContainerView.subviews)
        if ([subview isKindOfClass:[THZUICanvasElementView class]])
            [self recycleElementView:(THZUICanvasElementView*)subview];
}

- (THZUICanvasElementView*)elementViewForElement:(THZUICanvasElement*)element
{
    THZUICanvasElementView* elementView = [self.elementViewPool lastObject];
    if (elementView)
    {
        [self.elementViewPool removeObject:elementView];
        elementView.element = element;
        
    } else {
        
        elementView = [[[element.class viewClass] alloc] initWithElement:element
                                                          gestureHandler:self.elementViewGestureHandler];
    }
    
    if (element == self.rootElement) self.rootElementView = elementView;
    
    return elementView;
}

#pragma mark - Element View Selection

- (void)selectElementView:(THZUICanvasElementView*)elementView
{
    [self selectElementView:elementView startFromView:self.rootElementView];
}

- (void)selectElementView:(THZUICanvasElementView*)elementView
            startFromView:(THZUICanvasElementView*)startElementView
{
    startElementView.selected = (startElementView == elementView);
    for (UIView* subview in startElementView.childElementContainerView.subviews)
        if ([subview isKindOfClass:[THZUICanvasElementView class]])
            [self selectElementView:elementView startFromView:(THZUICanvasElementView*)subview];
}
                          
#pragma mark - Util

- (THZUICanvasElementView*)viewForElement:(THZUICanvasElement*)element
                                   inView:(THZUICanvasElementView*)elementView
{
    NSParameterAssert(element && elementView);
    
    if (elementView.element == element) return elementView;
    
    for (UIView* subview in elementView.childElementContainerView.subviews)
    {
        if (! [subview isKindOfClass:[THZUICanvasElementView class]]) continue;
        
        THZUICanvasElementView* eView = (THZUICanvasElementView*)subview;
        if (eView.element == element) return eView;
        
        THZUICanvasElementView* result = [self viewForElement:element inView:eView];
        if (result) return result;
    }
    
    return nil;
}

- (THZUICanvasElementView*)breadthFirstViewForElement:(THZUICanvasElement*)element
                                              inViews:(NSArray*)elementViews
{
    NSParameterAssert(element && elementViews);
    
    if ([elementViews count] == 0) return nil;
    
    for (THZUICanvasElementView* view in elementViews)
        if (view.element == element) return view;

    NSMutableArray* newElementViews = [NSMutableArray array];
    for (THZUICanvasElementView* view in elementViews)
        for (UIView* subview in view.childElementContainerView.subviews)
            if ([subview isKindOfClass:[THZUICanvasElementView class]])
                [newElementViews addObject:subview];
    
    return [self breadthFirstViewForElement:element inViews:newElementViews];
}

@end
