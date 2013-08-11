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
@property (nonatomic, readonly, assign) CGPoint center;
@property (nonatomic, readonly, assign) CGRect bounds;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, strong) UIColor* backgroundColor;

@property (nonatomic, weak) THCanvasElement* parentElement;
@property (nonatomic, strong) NSMutableSet* childElements;

@property (nonatomic, assign) BOOL modifiable;

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor;

- (void)addChildElement:(THCanvasElement*)childElement;

- (BOOL)translate:(CGPoint)translation;
- (BOOL)rotate:(CGFloat)rotation;
- (BOOL)scale:(CGFloat)scale;

@end
