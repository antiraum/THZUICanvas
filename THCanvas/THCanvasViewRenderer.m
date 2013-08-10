//
//  THCanvasViewRenderer.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasViewRenderer.h"
#import "THCanvasView.h"
#import "THCanvasElement.h"
#import "THCanvasElementView.h"

@interface THCanvasViewRenderer ()

@property (nonatomic, strong) NSCache* elementViewCache;
@property (nonatomic, weak) THCanvasElementView* rootElementView;
@property (nonatomic, strong) NSMutableArray* elementViewPool;

@end

@implementation THCanvasViewRenderer

- (id)init
{
    NSAssert(NO, @"use initWithView:rootElement:");
    return nil;
}

- (instancetype)initWithView:(THCanvasView *)view
                 rootElement:(THCanvasElement *)rootElement
   elementViewGestureHandler:(id<THCanvasElementGestureHandler>)elementViewGestureHandler
{
    NSParameterAssert(view && rootElement);
    
    self = [super init];
    if (self)
    {
        self.elementViewCache = [[NSCache alloc] init];
        self.elementViewPool = [NSMutableArray array];
        self.elementViewGestureHandler = elementViewGestureHandler;
        self.view = view;
        self.rootElement = rootElement;
    }
    return self;
}

#pragma mark - Properties

- (void)setView:(THCanvasView *)view
{
    NSParameterAssert(view);
    
    if (self.view == view) return;
    
    _view = view;
    
    if (self.rootElement)
        [self render];
}

- (void)setRootElement:(THCanvasElement *)rootElement
{
    NSParameterAssert(rootElement);
    
    if (self.rootElement == rootElement) return;
    
    _rootElement = rootElement;
    
    if (self.view)
        [self render];
}

#pragma mark - Rendering

- (void)render
{
    [self renderElement:self.rootElement];
}

- (void)renderElement:(THCanvasElement*)element
{
    NSParameterAssert(element);
    
    NSAssert(element == self.rootElement || self.rootElementView,
             @"trying to render elment subtree before root element was rendered");
    
    if (! self.rootElementView) element = self.rootElement;
    
    [self renderElement:element inParentView:self.rootElementView];
}

- (void)renderElement:(THCanvasElement*)element inParentView:(THCanvasElementView*)parentElementView
{
    THCanvasElementView* elementView = nil;
    if (parentElementView)
        elementView = [self viewForElement:element inView:parentElementView];
    
    if (elementView)
    {
        [elementView update];
        
        // remove obsolete child element views
        for (UIView* subview in elementView.subviews)
            if ([subview isKindOfClass:[THCanvasElementView class]]
                && ! [element.childElements containsObject:[(THCanvasElementView*)subview element]])
                [self recycleElementView:(THCanvasElementView*)subview];
        
    } else {
        
        elementView = [self elementViewForElement:element];
        UIView* superview = parentElementView ?: self.view;
        [superview addSubview:elementView];
    }
    
    for (THCanvasElement* childElement in element.childElements)
        [self renderElement:childElement inParentView:elementView];
}

- (void)recycleElementView:(THCanvasElementView*)elementView
{
    NSParameterAssert(elementView);
    
    if (elementView == self.rootElementView) self.rootElementView = nil;
    
    elementView.element = nil;
    [self.elementViewPool addObject:elementView];
    [elementView removeFromSuperview];
    
    for (UIView* subview in elementView.subviews)
        if ([subview isKindOfClass:[THCanvasElementView class]])
            [self recycleElementView:(THCanvasElementView*)subview];
}

- (THCanvasElementView*)elementViewForElement:(THCanvasElement*)element
{
    THCanvasElementView* elementView = [self.elementViewPool lastObject];
    if (elementView)
    {
        [self.elementViewPool removeObject:elementView];
        elementView.element = element;
        
    } else {
        
        elementView = [[THCanvasElementView alloc] initWithElement:element
                                                    gestureHandler:self.elementViewGestureHandler];
    }
    
    if (element == self.rootElement) self.rootElementView = elementView;
    
    return elementView;
}

- (void)renderRect:(CGRect)rect
{
    // TODO
}
                          
#pragma mark - Util

- (THCanvasElementView*)viewForElement:(THCanvasElement*)element
                                inView:(THCanvasElementView*)elementView
{
    NSParameterAssert(element && elementView);
    
    if (elementView.element == element) return elementView;
    
    for (UIView* subview in elementView.subviews)
    {
        if (! [subview isKindOfClass:[THCanvasElementView class]]) continue;
        
        THCanvasElementView* eView = (THCanvasElementView*)subview;
        if (eView.element == element) return eView;
        
        THCanvasElementView* result = [self viewForElement:element inView:eView];
        if (result) return result;
    }
    
    return nil;
}

- (THCanvasElementView*)breadthFirstViewForElement:(THCanvasElement*)element
                                           inViews:(NSArray*)elementViews
{
    NSParameterAssert(element && elementViews);
    
    if ([elementViews count] == 0) return nil;
    
    for (THCanvasElementView* view in elementViews)
        if (view.element == element) return view;

    NSMutableArray* newElementViews = [NSMutableArray array];
    for (THCanvasElementView* view in elementViews)
        for (UIView* subview in view.subviews)
            if ([subview isKindOfClass:[THCanvasElementView class]])
                [newElementViews addObject:subview];
    
    return [self breadthFirstViewForElement:element inViews:newElementViews];
}

@end
