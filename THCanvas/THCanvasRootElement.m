//
//  THCanvasRootElement.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THCanvasRootElement.h"

@implementation THCanvasRootElement

- (instancetype)initWithDataSource:(id<THCanvasElementDataSource>)dataSource
{
    self = [super initWithDataSource:dataSource];
    if (self)
    {
        self.modifiable = NO;
    }
    return self;
}

@end
