//
//  THCanvasViewController.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasViewController.h"
#import "THCanvasView.h"
#import "THCanvasViewRenderer.h"
#import "THCanvasViewInteractionController.h"
#import "THCanvasElementView.h"
#import "THCanvasElement.h"

@interface THCanvasViewController ()

@property (nonatomic, strong) THCanvasView* canvasView;
@property (nonatomic, strong) THCanvasViewRenderer* renderer;
@property (nonatomic, strong) THCanvasViewInteractionController* interactionController;

@end

@implementation THCanvasViewController

- (id)init
{
    NSAssert(NO, @"use initWithRootElement:");
    return nil;
}

- (instancetype)initWithRootElement:(THCanvasElement*)rootElement;
{
    NSParameterAssert(rootElement);
    
    self = [super init];
    if (self)
    {
        self.canvasView = [[THCanvasView alloc] init];
        self.rootElement = rootElement;
        self.interactionController = [[THCanvasViewInteractionController alloc] init];
        self.renderer = [[THCanvasViewRenderer alloc] initWithView:self.canvasView
                                                       rootElement:self.rootElement
                                         elementViewGestureHandler:self.interactionController];
        self.interactionController.renderer = self.renderer;
    }
    return self;
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

- (THCanvasView *)canvasView
{
    return (THCanvasView*)self.view;
}

- (void)setCanvasView:(THCanvasView *)canvasView
{
    NSParameterAssert(canvasView);
    
    if (self.canvasView == canvasView) return;
    
    self.view = canvasView;
    self.renderer.view = self.canvasView;
}

- (void)setRootElement:(THCanvasElement *)rootElement
{
    NSParameterAssert(rootElement);
    
    if (self.rootElement == rootElement) return;
    
    _rootElement = rootElement;
    self.renderer.rootElement = self.rootElement;
}

@end
