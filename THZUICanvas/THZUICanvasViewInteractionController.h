//
//  THZUICanvasViewInteractionController.h
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THZUICanvasViewRenderer;

@protocol THZUICanvasElementGestureHandler <NSObject, UIGestureRecognizerDelegate>

- (void)handleElementViewSingleTapGesture:(UITapGestureRecognizer*)recognizer;
- (void)handleElementViewDoubleTapGesture:(UITapGestureRecognizer*)recognizer;
- (void)handleElementViewLongPressGesture:(UILongPressGestureRecognizer*)recognizer;
- (void)handleElementViewPanGesture:(UIPanGestureRecognizer*)recognizer;
- (void)handleElementViewRotationGesture:(UIRotationGestureRecognizer*)recognizer;
- (void)handleElementViewPinchGesture:(UIPinchGestureRecognizer*)recognizer;

@end

@interface THZUICanvasViewInteractionController : NSObject <THZUICanvasElementGestureHandler>

@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) THZUICanvasViewRenderer* renderer;

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                          renderer:(THZUICanvasViewRenderer*)renderer;

@end
