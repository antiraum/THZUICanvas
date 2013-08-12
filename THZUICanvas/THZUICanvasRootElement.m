//
//  THZUICanvasRootElement.m
//  THZUICanvas
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasRootElement.h"

@implementation THZUICanvasRootElement

- (instancetype)initWithDataSource:(id<THZUICanvasElementDataSource>)dataSource
{
    self = [super initWithDataSource:dataSource];
    if (self)
    {
        self.modifiable = NO;
    }
    return self;
}

@end
