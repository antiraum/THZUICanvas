//
//  THCanvasImageElementView.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasImageElementView.h"
#import "THCanvasImageElement.h"
#import "THWeakSelf.h"

@interface THCanvasImageElementView ()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, readonly, strong) THCanvasImageElement* imageElement;

@end

@implementation THCanvasImageElementView

- (instancetype)initWithElement:(THCanvasElement *)element gestureHandler:(id<THCanvasElementGestureHandler>)gestureHandler
{
    self = [super initWithElement:element gestureHandler:gestureHandler];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        static dispatch_queue_t imageLoadingQueue = nil;
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            imageLoadingQueue =
            dispatch_queue_create("name.thomashess.THCanvas.THCanvasImageElementView.imageLoading",
                                  DISPATCH_QUEUE_CONCURRENT);
            dispatch_set_target_queue(imageLoadingQueue,
                                      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        });

        THWeakSelf wself = self;
        dispatch_async(imageLoadingQueue, ^{
            
            NSData* imageData = [NSData dataWithContentsOfURL:wself.imageElement.imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                wself.imageView.image = [UIImage imageWithData:imageData];
            });
        });
    }
    return self;
}

- (THCanvasImageElement*)imageElement
{
    return (THCanvasImageElement*)self.element;
}

@end
