//
//  THViewController.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THViewController.h"
#import "THCanvasElement.h"
#import "THCanvasViewController.h"

@interface THViewController ()

@property (nonatomic, strong) THCanvasElement* rootElement;
@property (nonatomic, strong) THCanvasViewController* canvasVC;

@end

@implementation THViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.rootElement = [[THCanvasElement alloc] initWithFrame:self.view.bounds
                                              backgroundColor:[UIColor clearColor]];
    self.rootElement.modifiable = NO;
    [self.rootElement addChildElement:[[THCanvasElement alloc] initWithFrame:CGRectMake(10, 10, 100, 100)
                                                             backgroundColor:[UIColor redColor]]];
    [self.rootElement addChildElement:[[THCanvasElement alloc] initWithFrame:CGRectMake(50, 120, 150, 150)
                                                             backgroundColor:[UIColor blueColor]]];
    THCanvasElement* greenElement = [[THCanvasElement alloc] initWithFrame:CGRectMake(150, 20, 250, 250)
                                                           backgroundColor:[UIColor greenColor]];
    [greenElement addChildElement:[[THCanvasElement alloc] initWithFrame:CGRectMake(5, 5, 10, 50)
                                                         backgroundColor:[UIColor purpleColor]]];
    [self.rootElement addChildElement:greenElement];
    
    self.canvasVC = [[THCanvasViewController alloc] initWithRootElement:self.rootElement];
    self.canvasVC.view.frame = self.view.bounds;
    [self.view addSubview:self.canvasVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
