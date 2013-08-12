//
//  THZUICanvasViewRenderer.h
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THZUICanvasViewInteractionController.h"

@class THZUICanvasElement;
@class THZUICanvasElementView;

@interface THZUICanvasViewRenderer : NSObject

@property (nonatomic, strong) UIView* view;
@property (nonatomic, strong) THZUICanvasElement* rootElement;
@property (nonatomic, weak) id<THZUICanvasElementGestureHandler> elementViewGestureHandler;

- (instancetype)initWithView:(UIView*)view
                 rootElement:(THZUICanvasElement*)rootElement
   elementViewGestureHandler:(id<THZUICanvasElementGestureHandler>)elementViewGestureHandler;

- (void)render;
- (void)renderElement:(THZUICanvasElement*)element;
- (void)renderRect:(CGRect)rect;

- (void)selectElementView:(THZUICanvasElementView*)elementView;

@end
