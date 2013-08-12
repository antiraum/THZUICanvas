//
//  THZUICanvasElementView.m
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasElementView.h"
#import "THZUICanvasElement.h"

@interface THZUICanvasElementView ()

@property (nonatomic, readwrite, strong) UIView* childElementContainerView;

@end

@implementation THZUICanvasElementView

- (id)init
{
    NSAssert(NO, @"use initWithElement:gestureHandler:");
    return nil;
}

- (instancetype)initWithElement:(THZUICanvasElement*)element
                 gestureHandler:(id<THZUICanvasElementGestureHandler>)gestureHandler
{
    NSParameterAssert(element && gestureHandler);
    
    self = [super init];
    if (self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor blueColor] CGColor]; // selection border
        
        self.element = element;
        self.gestureHandler = gestureHandler;
        
        self.childElementContainerView = [[UIView alloc] initWithFrame:self.bounds];
        self.childElementContainerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                                           | UIViewAutoresizingFlexibleHeight);
        [self addSubview:self.childElementContainerView];
        
        if (self.element.modifiable)
        {
            UITapGestureRecognizer* singleTapRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self.gestureHandler
                                                    action:@selector(handleElementViewSingleTapGesture:)];
            singleTapRecognizer.numberOfTapsRequired = 1;
            singleTapRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:singleTapRecognizer];
            
            UITapGestureRecognizer* doubleTapRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self.gestureHandler
                                                    action:@selector(handleElementViewDoubleTapGesture:)];
            doubleTapRecognizer.numberOfTapsRequired = 2;
            doubleTapRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:doubleTapRecognizer];
            
            UILongPressGestureRecognizer* longPressRecognizer =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self.gestureHandler
                                                          action:@selector(handleElementViewLongPressGesture:)];
            longPressRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:longPressRecognizer];
            
            UIPanGestureRecognizer* panRecognizer =
            [[UIPanGestureRecognizer alloc] initWithTarget:self.gestureHandler
                                                    action:@selector(handleElementViewPanGesture:)];
            panRecognizer.maximumNumberOfTouches = 1;
            panRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:panRecognizer];
            
            UIRotationGestureRecognizer* rotationRecognizer =
            [[UIRotationGestureRecognizer alloc] initWithTarget:self.gestureHandler
                                                         action:@selector(handleElementViewRotationGesture:)];
            rotationRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:rotationRecognizer];
            
            UIPinchGestureRecognizer* pinchRecognizer =
            [[UIPinchGestureRecognizer alloc] initWithTarget:self.gestureHandler
                                                      action:@selector(handleElementViewPinchGesture:)];
            pinchRecognizer.delegate = self.gestureHandler;
            [self addGestureRecognizer:pinchRecognizer];
        }
    }
    return self;
}

#pragma mark - Properties

- (void)setElement:(THZUICanvasElement *)element
{
    if (self.element == element) return;
    
    _element = element;
    
    [self update];
}

- (void)setSelected:(BOOL)selected
{
    if (self.selected == selected) return;
    
    DLog(@"%@ %d %d", self, self.selected, selected);
    _selected = selected;
    
    self.layer.borderWidth = (selected) ? 4 : 0;
}

#pragma mark - Public Methods

- (void)update
{
    if (! self.element) return;
    
    self.transform = CGAffineTransformIdentity;
    self.frame = self.element.frame;
    if (self.element.rotation != 0)
        self.transform = CGAffineTransformMakeRotation(self.element.rotation);
}

@end
