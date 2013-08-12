//
//  CATransaction+THAdditions.m
//  THCanvasDemo
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "CATransaction+THAdditions.h"

@implementation CATransaction (THAdditions)

+ (void)wrapInTransactionWithDisabledActions:(void(^)())transactionBlock
{
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	transactionBlock();
	[CATransaction commit];
}

@end
