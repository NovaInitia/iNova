//
//  AppDelegate.m
//  iNova
//
//  Created by Kyle Hughes and Eric O'Connell on 3/31/12.
//  Copyright (c) 2012 Code Monkey Upstairs. All rights reserved.
//

#import "AppDelegate.h"
#import "DevelopmentViewController.h"
#import "LoginViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "User.h"
#import "NI_API.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize navigationController = _navigationController;
@synthesize rootViewController = _rootViewController;

static const CGFloat MENU_DELTA = 65;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(4);
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initiateEverything];
    
    return YES;
}

- (void) initiateEverything
{
    // Override point for customization after application launch.
    
    UIViewController* startingViewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        startingViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
    } else {
        startingViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
    }
    
    [startingViewController setTitle:@"Login"];
    
    // Web View
    self.webView = [[UIWebView alloc] init];
    NSURL* url = [NSURL URLWithString:@""];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // Root View Controller
    self.rootViewController = [[UIViewController alloc] init];
    self.rootViewController.view.frame = [[UIScreen mainScreen] bounds];
    
    // Navigation Controller
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:startingViewController];
    [[self.navigationController.view layer] setShadowOffset:CGSizeMake(2, 0)];
    [[self.navigationController.view layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.navigationController.view layer] setShadowRadius:6];
    [[self.navigationController.view layer] setShadowOpacity:.7];
    [self.navigationController.view layer].shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.view.bounds].CGPath; // Super speed boost
    
    // Menu Controller
    CGRect frame = self.navigationController.view.frame;
    frame.origin.x += MENU_DELTA;
    frame.size.width -= MENU_DELTA;
    [MenuViewController sharedInstance].view.frame = frame;
    
    // Setup Subviews
    [self.rootViewController.view addSubview:self.navigationController.view];
    [self.rootViewController.view insertSubview:[MenuViewController sharedInstance].view belowSubview:self.navigationController.view];
    
    self.window.rootViewController = self.rootViewController;
    
    [self.window makeKeyAndVisible];

}

- (void) logout
{
    [[User sharedInstance] logout];
    [[MenuViewController sharedInstance] logout];
    [NI_API sharedInstance].lastKey = nil;
    [self initiateEverything];
}

+ (NSString*) determineNib:(NSString*) viewControllerName
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return [viewControllerName stringByAppendingString:@"_iPhone"];
    } else {
        return [viewControllerName stringByAppendingString:@"_iPad"];
    }
}

+ (CGFloat) MENU_DELTA
{
    return(MENU_DELTA);
}


/*
    NOTE: In practice we only want to use this when loading URLs from outside of the WebSpaceViewController
 */
- (void) loadURLFromString:(NSString *)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:modifiedURLString];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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

@end
