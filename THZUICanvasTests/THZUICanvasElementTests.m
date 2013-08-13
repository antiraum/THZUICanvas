//
//  THZUICanvasElementTests.m
//  THZUICanvas
//
//  Created by Thomas Heß on 12.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "THZUICanvasElement.h"
#import "THFloatEqualToFloat.h"

@interface THZUICanvasElementTests : XCTestCase <THZUICanvasElementDataSource>

@end

@implementation THZUICanvasElementTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInit
{
    THZUICanvasElement* element = [[THZUICanvasElement alloc] initWithDataSource:self];
    XCTAssertEqual(element.frame.size, self.canvasElementMinSize,
                    @"canvasElementMinSize not respected");
    CGRect smallFrame = CGRectMake(0, 0, 10, 10);
    element.frame = smallFrame;
    XCTAssertEqual(element.frame.size, self.canvasElementMinSize,
                    @"canvasElementMinSize not respected");
    CGRect properFrame = CGRectMake(0, 0, 110, 120);
    element.frame = properFrame;
    XCTAssertEqual(element.frame, properFrame, @"frame not properly set");
}

- (void)testAddChildElement
{
    THZUICanvasElement* parent = [[THZUICanvasElement alloc] initWithDataSource:self];
    THZUICanvasElement* child1 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child1];
    XCTAssertTrue([parent.childElements count] == 1, @"first child not added");
    THZUICanvasElement* child2 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child2];
    XCTAssertTrue([parent.childElements count] == 2, @"second child not added");
    XCTAssertEqual([parent.childElements lastObject], child2, @"child order wrong");
    child1.frame = CGRectMake(1000, 1000, 1000, 1000);
    XCTAssertEqual(child1.frame.size, self.canvasElementMinSize, @"invalid frame accepted");
}

- (void)testRemoveChildElement
{
    THZUICanvasElement* parent = [[THZUICanvasElement alloc] initWithDataSource:self];
    THZUICanvasElement* child1 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child1];
    THZUICanvasElement* child2 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child2];
    [parent removeChildElement:child1];
    XCTAssertTrue([parent.childElements count] == 1, @"child not removed");
    XCTAssertEqual([parent.childElements lastObject], child2, @"wrong child removed");
}

- (void)testBringChildElementToFront
{
    THZUICanvasElement* parent = [[THZUICanvasElement alloc] initWithDataSource:self];
    THZUICanvasElement* child1 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child1];
    THZUICanvasElement* child2 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child2];
    THZUICanvasElement* child3 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child3];
    [parent bringChildElementToFront:child1];
    XCTAssertEqual(parent.childElements[0], child2, @"wrong child order");
    XCTAssertEqual(parent.childElements[1], child3, @"wrong child order");
    XCTAssertEqual(parent.childElements[2], child1, @"wrong child order");
    [parent bringChildElementToFront:child3];
    XCTAssertEqual(parent.childElements[0], child2, @"wrong child order");
    XCTAssertEqual(parent.childElements[1], child1, @"wrong child order");
    XCTAssertEqual(parent.childElements[2], child3, @"wrong child order");
    [parent bringChildElementToFront:child3];
    XCTAssertEqual(parent.childElements[0], child2, @"wrong child order");
    XCTAssertEqual(parent.childElements[1], child1, @"wrong child order");
    XCTAssertEqual(parent.childElements[2], child3, @"wrong child order");
}

- (void)testSendChildElementToBack
{
    THZUICanvasElement* parent = [[THZUICanvasElement alloc] initWithDataSource:self];
    THZUICanvasElement* child1 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child1];
    THZUICanvasElement* child2 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child2];
    THZUICanvasElement* child3 = [[THZUICanvasElement alloc] initWithDataSource:self];
    [parent addChildElement:child3];
    [parent sendChildElementToBack:child3];
    XCTAssertEqual(parent.childElements[0], child3, @"wrong child order");
    XCTAssertEqual(parent.childElements[1], child1, @"wrong child order");
    XCTAssertEqual(parent.childElements[2], child2, @"wrong child order");
    [parent sendChildElementToBack:child1];
    XCTAssertEqual(parent.childElements[0], child1, @"wrong child order");
    XCTAssertEqual(parent.childElements[1], child3, @"wrong child order");
    XCTAssertEqual(parent.childElements[2], child2, @"wrong child order");
    [parent sendChildElementToBack:child1];
    XCTAssertEqual(parent.childElements[0], child1, @"wrong child order");
    XCTAssertEqual(parent.childElements[1], child3, @"wrong child order");
    XCTAssertEqual(parent.childElements[2], child2, @"wrong child order");
}

- (void)testTranslate
{
    THZUICanvasElement* element = [[THZUICanvasElement alloc] initWithDataSource:self];
    element.frame = CGRectMake(100, 100, 500, 500);
    XCTAssertTrue([element translate:CGPointMake(100, 100)], @"failed to translate");
    XCTAssertTrue(CGPointEqualToPoint(element.frame.origin, CGPointMake(200, 200)),
                  @"wrong translation");
    XCTAssertTrue([element translate:CGPointMake(-100, -100)], @"failed to translate");
    XCTAssertTrue(CGPointEqualToPoint(element.frame.origin, CGPointMake(100, 100)),
                  @"wrong translation");
    element.modifiable = NO;
    XCTAssertFalse([element translate:CGPointMake(-100, -100)], @"non-modifiable not respected");
}

- (void)testRotate
{
    THZUICanvasElement* element = [[THZUICanvasElement alloc] initWithDataSource:self];
    XCTAssertTrue(element.rotation == 0, @"wrong initial rotation");
    XCTAssertTrue([element rotate:M_PI], @"failed to rotate");
    XCTAssertEqualWithAccuracy(element.rotation, M_PI, THFloatComparisonEpsilon, @"wrong rotation");
    XCTAssertTrue([element rotate:-3*M_PI], @"failed to rotate");;
    XCTAssertEqualWithAccuracy(element.rotation, 0, THFloatComparisonEpsilon, @"wrong rotation");
    XCTAssertFalse([element rotate:NAN], @"rotated despite NAN");;
    XCTAssertEqualWithAccuracy(element.rotation, 0, THFloatComparisonEpsilon, @"wrong rotation");
    element.modifiable = NO;
    XCTAssertFalse([element rotate:M_PI], @"non-modifiable not respected");
}

- (void)testScale
{
    THZUICanvasElement* element = [[THZUICanvasElement alloc] initWithDataSource:self];
    element.frame = CGRectMake(100, 100, 100, 100);
    XCTAssertTrue([element scale:2], @"failed to scale");
    XCTAssertEqual(element.frame, CGRectMake(50, 50, 200, 200), @"wrong scaling");
    XCTAssertFalse([element scale:-2], @"scaled with negative scale");
    XCTAssertEqual(element.frame, CGRectMake(50, 50, 200, 200), @"wrong scaling");
    XCTAssertFalse([element scale:NAN], @"scaled despite NAN");
    XCTAssertEqual(element.frame, CGRectMake(50, 50, 200, 200), @"wrong scaling");
    XCTAssertTrue([element scale:0.5], @"failed to scale");
    XCTAssertEqual(element.frame, CGRectMake(100, 100, 100, 100), @"wrong scaling");
}

#pragma mark - THZUICanvasElementDataSource

- (CGSize)canvasElementMinSize
{
    return CGSizeMake(100, 100);
}

@end
