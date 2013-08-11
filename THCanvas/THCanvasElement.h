//
//  THCanvasElement.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THCanvasElementDataSource <NSObject>

@property (nonatomic, readonly, assign) CGSize canvasElementMinSize;

@end

@interface THCanvasElement : NSObject

@property (nonatomic, readonly, assign) Class viewClass;

@property (nonatomic, weak) id<THCanvasElementDataSource>dataSource;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, readonly, assign) CGPoint center;
@property (nonatomic, readonly, assign) CGRect bounds;
@property (nonatomic, assign) CGFloat rotation;

@property (nonatomic, weak) THCanvasElement* parentElement;
@property (nonatomic, readonly, strong) NSSet* childElements;

@property (nonatomic, assign) BOOL modifiable;

- (instancetype)initWithDataSource:(id<THCanvasElementDataSource>)dataSource;

- (void)addChildElement:(THCanvasElement*)childElement;
- (void)removeChildElement:(THCanvasElement*)childElement;

- (BOOL)translate:(CGPoint)translation;
- (BOOL)rotate:(CGFloat)rotation;
- (BOOL)scale:(CGFloat)scale;

@end
