//
//  THZUICanvasViewController.h
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THZUICanvasElement;

@interface THZUICanvasViewController : UIViewController

@property (nonatomic, strong) THZUICanvasElement* rootElement;

- (instancetype)initWithCanvasSize:(CGSize)canvasSize rootElement:(THZUICanvasElement*)rootElement;

@end
