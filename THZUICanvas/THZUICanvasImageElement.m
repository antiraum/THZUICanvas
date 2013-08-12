//
//  THZUICanvasImageElement.m
//  THZUICanvas
//
//  Created by Thomas Heß on 11.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THZUICanvasImageElement.h"
#import "THZUICanvasImageElementView.h"

@implementation THZUICanvasImageElement

- (Class)viewClass
{
    return [THZUICanvasImageElementView class];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ (%@)",
            [super description], [self.imageURL lastPathComponent]];
}

@end
