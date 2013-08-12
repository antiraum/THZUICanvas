//
//  CATransaction+THAdditions.h
//  THCanvasDemo
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransaction (THAdditions)

+ (void)wrapInTransactionWithDisabledActions:(void(^)())transactionBlock;

@end
