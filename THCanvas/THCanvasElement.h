//
//  THCanvasElement.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCanvasElement : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, assign) BOOL nonModifiable;
@property (nonatomic, weak) THCanvasElement* parentElement;
@property (nonatomic, strong) NSMutableSet* childElements;

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor;

- (void)addChildElement:(THCanvasElement*)childElement;

- (void)translate:(CGPoint)translation;
- (void)rotate:(CGFloat)rotation;
- (void)scale:(CGFloat)scale;

@end
