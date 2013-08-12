//
//  THZUICanvasElementView.h
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THZUICanvasViewInteractionController.h"

@class THZUICanvasElement;

@interface THZUICanvasElementView : UIView

@property (nonatomic, strong) THZUICanvasElement* element;
@property (nonatomic, weak) id<THZUICanvasElementGestureHandler> gestureHandler;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithElement:(THZUICanvasElement*)element
                 gestureHandler:(id<THZUICanvasElementGestureHandler>)gestureHandler;
- (void)update;

@end
