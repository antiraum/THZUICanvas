//
//  THCanvasViewController.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THCanvasElement;

@interface THCanvasViewController : UIViewController

@property (nonatomic, strong) THCanvasElement* rootElement;

- (instancetype)initWithRootElement:(THCanvasElement*)rootElement;

@end
