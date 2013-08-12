//
//  THZUICanvasViewController.m
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasViewController.h"
#import "THZUICanvasViewRenderer.h"
#import "THZUICanvasViewInteractionController.h"
#import "THZUICanvasElementView.h"
#import "THZUICanvasElement.h"

@interface THZUICanvasViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* canvasView;
@property (nonatomic, strong) THZUICanvasViewRenderer* renderer;
@property (nonatomic, strong) THZUICanvasViewInteractionController* interactionController;

@end

@implementation THZUICanvasViewController

- (id)init
{
    NSAssert(NO, @"use initWithCanvasSize:rootElement:");
    return nil;
}

- (instancetype)initWithCanvasSize:(CGSize)canvasSize rootElement:(THZUICanvasElement*)rootElement
{
    NSParameterAssert(! CGSizeEqualToSize(CGSizeZero, canvasSize) && rootElement);
    
    self = [super init];
    if (self)
    {
        self.rootElement = rootElement;
        self.rootElement.frame = (CGRect) { .size = canvasSize };
        
        self.canvasView = [[UIView alloc] initWithFrame:(CGRect) { .size = canvasSize }];
        [self.scrollView addSubview:self.canvasView];
        self.scrollView.contentSize = canvasSize;
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = MIN(1,
                                               MIN(self.view.bounds.size.width / canvasSize.width,
                                                   self.view.bounds.size.height / canvasSize.height));
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        self.scrollView.bouncesZoom = NO;
        
        self.interactionController = [[THZUICanvasViewInteractionController alloc] init];
        self.renderer = [[THZUICanvasViewRenderer alloc] initWithView:self.canvasView
                                                       rootElement:self.rootElement
                                         elementViewGestureHandler:self.interactionController];
        self.interactionController.renderer = self.renderer;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIScrollView*)scrollView
{
    return (UIScrollView*)self.view;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    NSParameterAssert(scrollView);
    
    if (self.scrollView == scrollView) return;
    
    self.view = scrollView;
}

- (void)setCanvasView:(UIView*)canvasView
{
    NSParameterAssert(canvasView);
    
    if (self.canvasView == canvasView) return;
    
    _canvasView = canvasView;
    self.renderer.view = self.canvasView;
}

- (void)setRootElement:(THZUICanvasElement*)rootElement
{
    NSParameterAssert(rootElement);
    
    if (self.rootElement == rootElement) return;
    
    _rootElement = rootElement;
    self.renderer.rootElement = self.rootElement;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.canvasView;
}

@end
