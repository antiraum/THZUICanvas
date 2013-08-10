//
//  THCanvasViewRenderer.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THCanvasViewInteractionController.h"

@class THCanvasView;
@class THCanvasElement;

@interface THCanvasViewRenderer : NSObject

@property (nonatomic, strong) THCanvasView* view;
@property (nonatomic, strong) THCanvasElement* rootElement;
@property (nonatomic, weak) id<THCanvasElementGestureHandler> elementViewGestureHandler;

- (instancetype)initWithView:(THCanvasView*)view
                 rootElement:(THCanvasElement*)rootElement
   elementViewGestureHandler:(id<THCanvasElementGestureHandler>)elementViewGestureHandler;

- (void)render;
- (void)renderElement:(THCanvasElement*)element;
- (void)renderRect:(CGRect)rect;

@end
