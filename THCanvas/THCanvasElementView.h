//
//  THCanvasElementView.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCanvasViewInteractionController.h"

@class THCanvasElement;

@interface THCanvasElementView : UIView

@property (nonatomic, strong) THCanvasElement* element;
@property (nonatomic, weak) id<THCanvasElementGestureHandler> gestureHandler;

- (instancetype)initWithElement:(THCanvasElement*)element
                 gestureHandler:(id<THCanvasElementGestureHandler>)gestureHandler;
- (void)update;

@end
