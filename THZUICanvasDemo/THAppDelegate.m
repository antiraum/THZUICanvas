//
//  THAppDelegate.m
//  THZUICanvasDemo
//
//  Created by Thomas Heß on 10.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import "THAppDelegate.h"
#import "THZUICanvasViewController.h"
#import "THZUICanvasRootElement.h"
#import "THZUICanvasImageElement.h"

@interface THAppDelegate () <THZUICanvasElementDataSource>

@property (nonatomic, strong) THZUICanvasViewController* viewController;

@end

@implementation THAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGSize canvasSize = CGSizeMake(2 * self.window.bounds.size.width,
                                   2 * self.window.bounds.size.height);
    
    THZUICanvasRootElement* rootElement = [THZUICanvasRootElement canvasElementWithDataSource:self];
    rootElement.frame = (CGRect) { .size = canvasSize };
    THZUICanvasImageElement* childElement1 = [THZUICanvasImageElement canvasElementWithDataSource:self];
    [rootElement addChildElement:childElement1];
    childElement1.frame = CGRectMake(100, 100, 400, 600);
    childElement1.imageURL = [NSURL URLWithString:@"http://www.public-domain-photos.com/free-stock-photos-4/flowers/button-flowers.jpg"];
    THZUICanvasImageElement* childElement2 = [THZUICanvasImageElement canvasElementWithDataSource:self];
    [rootElement addChildElement:childElement2];
    childElement2.frame = CGRectMake(800, 750, 600, 750);
    childElement2.imageURL = [NSURL URLWithString:@"http://www.public-domain-photos.com/free-stock-photos-4/flowers/pink-flowers.jpg"];
    THZUICanvasImageElement* childElement3 = [THZUICanvasImageElement canvasElementWithDataSource:self];
    [rootElement addChildElement:childElement3];
    childElement3.frame = CGRectMake(450, 350, 750, 750);
    childElement3.imageURL = [NSURL URLWithString:@"http://www.public-domain-photos.com/free-stock-photos-4/flowers/hibiscus-3.jpg"];
    THZUICanvasImageElement* childElement4 = [THZUICanvasImageElement canvasElementWithDataSource:self];
    [childElement3 addChildElement:childElement4];
    childElement4.frame = CGRectMake(100, 100, 400, 250);
    childElement4.imageURL = [NSURL URLWithString:@"http://www.public-domain-photos.com/free-stock-photos-3/flowers/red-tulips.jpg"];
    
    self.viewController = [[THZUICanvasViewController alloc] initWithCanvasSize:canvasSize
                                                                    rootElement:rootElement];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - THZUICanvasElementDataSource

- (CGSize)canvasElementMinSize
{
    return CGSizeMake(75, 75);
}

@end
