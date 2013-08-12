//
//  THZUICanvasImageElementView.m
//  THZUICanvas
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasImageElementView.h"
#import "THZUICanvasImageElement.h"
#import "THWeakSelf.h"

@interface THZUICanvasImageElementView ()

@property (nonatomic, strong) UIActivityIndicatorView* activityView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, readonly, strong) THZUICanvasImageElement* imageElement;

@end

@implementation THZUICanvasImageElementView

- (instancetype)initWithElement:(THZUICanvasElement *)element gestureHandler:(id<THZUICanvasElementGestureHandler>)gestureHandler
{
    self = [super initWithElement:element gestureHandler:gestureHandler];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                           | UIViewAutoresizingFlexibleHeight);
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = self.bounds;
        self.activityView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                              | UIViewAutoresizingFlexibleHeight);
        self.activityView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.activityView.layer.borderWidth = 2;
        [self.activityView startAnimating];
        [self addSubview:self.activityView];
        
        static dispatch_queue_t imageLoadingQueue = nil;
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            imageLoadingQueue =
            dispatch_queue_create("name.thomashess.THZUICanvas.THZUICanvasImageElementView.imageLoading",
                                  DISPATCH_QUEUE_CONCURRENT);
            dispatch_set_target_queue(imageLoadingQueue,
                                      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        });

        THWeakSelf wself = self;
        dispatch_async(imageLoadingQueue, ^{
            
            NSData* imageData = [NSData dataWithContentsOfURL:wself.imageElement.imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                wself.imageView.image = [UIImage imageWithData:imageData];
                [wself.activityView removeFromSuperview];
                wself.activityView = nil;
            });
        });
    }
    return self;
}

- (THZUICanvasImageElement*)imageElement
{
    return (THZUICanvasImageElement*)self.element;
}

@end
