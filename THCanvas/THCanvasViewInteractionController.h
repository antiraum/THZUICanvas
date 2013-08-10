//
//  THCanvasViewInteractionController.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THCanvasViewRenderer;

@protocol THCanvasElementGestureHandler <NSObject>

- (void)handleElementViewTapGesture:(UITapGestureRecognizer*)recognizer;
- (void)handleElementViewPanGesture:(UIPanGestureRecognizer*)recognizer;
- (void)handleElementViewRotationGesture:(UIRotationGestureRecognizer*)recognizer;
- (void)handleElementViewPinchGesture:(UIPinchGestureRecognizer*)recognizer;

@end

@interface THCanvasViewInteractionController : NSObject <THCanvasElementGestureHandler>

@property (nonatomic, strong) THCanvasViewRenderer* renderer;

- (instancetype)initWithRenderer:(THCanvasViewRenderer*)renderer;

@end
