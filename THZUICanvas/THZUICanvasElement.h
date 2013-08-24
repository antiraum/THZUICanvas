//
//  THZUICanvasElement.h
//  THZUICanvas
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THZUICanvasElementDataSource <NSObject>

@property (nonatomic, readonly, assign) CGSize canvasElementMinSize;

@end

@interface THZUICanvasElement : NSObject

@property (nonatomic, weak) id<THZUICanvasElementDataSource>dataSource;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, readonly, assign) CGPoint center;
@property (nonatomic, readonly, assign) CGRect bounds;
@property (nonatomic, assign) CGFloat rotation;

@property (nonatomic, weak) THZUICanvasElement* parentElement;
@property (nonatomic, readonly, strong) NSOrderedSet* childElements;

@property (nonatomic, assign) BOOL modifiable;

+ (Class)viewClass;

+ (instancetype)canvasElementWithDataSource:(id<THZUICanvasElementDataSource>)dataSource;
- (instancetype)initWithDataSource:(id<THZUICanvasElementDataSource>)dataSource;

- (void)addChildElement:(THZUICanvasElement*)childElement;
- (void)removeChildElement:(THZUICanvasElement*)childElement;

- (BOOL)bringChildElementToFront:(THZUICanvasElement*)childElement;
- (BOOL)sendChildElementToBack:(THZUICanvasElement*)childElement;

- (BOOL)translate:(CGPoint)translation;
- (BOOL)rotate:(CGFloat)rotation;
- (BOOL)scale:(CGFloat)scale;

@end
