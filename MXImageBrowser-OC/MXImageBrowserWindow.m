//
//  MXImageBrowserWindow.m
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXImageBrowserWindow.h"
#import "MXImageBrowserManager.h"
#import "MXImageBrowser.h"

@interface MXImageBrowserWindow ()
/**
 *  Will not return `rootViewController` while this value is `true`. Or the rotation will be fucked in iOS 9.
 */
@property (nonatomic, assign, getter=isStatusBarOrientationChanging) BOOL statusBarOrientationChanging;
@property (nonatomic, assign, readonly) BOOL shouldRotateManually;
@end

@implementation MXImageBrowserWindow
+ (instancetype)defaultWindow {
    static MXImageBrowserWindow *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MXImageBrowserWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return instance;
}

/**
 *   Don't rotate manually if the application:
 *    - is running on iPad
 *    - is running on iOS 9
 *    - supports all orientations
 *    - doesn't require full screen
 *    - has launch storyboard
 *
 *  @return should Rotate Manually
 */
- (BOOL)shouldRotateManually {
    BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [[application delegate] window];
    BOOL supportsAllOrientations = [application supportedInterfaceOrientationsForWindow:window] == UIInterfaceOrientationMaskAll;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    BOOL requiresFullScreen = [[info objectForKey:@"UIRequiresFullScreen"] boolValue];
    BOOL hasLaunchStoryboard = ([info objectForKey:@"UILaunchStoryboardName"] != nil);
    
    BOOL iOS9AndLater = [[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending;
    
    if (iOS9AndLater) {
        if (iPad &&
            supportsAllOrientations &&
            !requiresFullScreen &&
            hasLaunchStoryboard) {
            return NO;
        }
    }
    return YES;
}

- (UIViewController *)controller {
    if (_controller == nil) {
        _controller = [UIViewController new];
    }
    return _controller;
}

- (UIViewController *)rootViewController {
    if ([self isStatusBarOrientationChanging]) {
        return nil;
    }
    return [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
}

//- (void)setRootViewController:(UIViewController *)rootViewController {
//    // Do nothing
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setUserInteractionEnabled:NO];
        [self setWindowLevel:UIWindowLevelStatusBar];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:NO];
        [self handleRotate:[[UIApplication sharedApplication] statusBarOrientation]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bringWindowToTop:)
                                                     name:UIWindowDidBecomeVisibleNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationWillChange)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationDidChange)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

/**
 Bring MXToastWindow to top when another window is being shown.
 
 - parameter notification: NSNotification
 */
- (void)bringWindowToTop:(NSNotification *)notification {
    if ([notification object] == nil || ![[notification object] isKindOfClass:[MXImageBrowserWindow class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{            
//            [[MXImageBrowserWindow defaultWindow] setHidden:YES];
            [[MXImageBrowserWindow defaultWindow] setHidden:NO];
        });
    }
}

- (void)statusBarOrientationWillChange {
    [self setStatusBarOrientationChanging:YES];
}

- (void)statusBarOrientationDidChange {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self handleRotate:orientation];
    [self setStatusBarOrientationChanging:NO];
}

- (void)applicationDidBecomeActive {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self handleRotate:orientation];
}

- (void)handleRotate:(UIInterfaceOrientation)orientation {
    
    CGFloat angle = [self angleForOrientation:orientation];
    if ([self shouldRotateManually]) {
        [self setTransform:CGAffineTransformMakeRotation(angle)];
    }
    
    UIWindow *window;
    if ([[[UIApplication sharedApplication] windows] count]) {
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }
    
    CGRect frame = [self frame];
    if (window != nil) {
        if (orientation == UIInterfaceOrientationPortrait ||
            orientation == UIInterfaceOrientationPortraitUpsideDown ||
            ![self shouldRotateManually]) {
            frame.size.width = window.bounds.size.width;
            frame.size.height = window.bounds.size.height;
        } else {
            frame.size.width = window.bounds.size.height;
            frame.size.height = window.bounds.size.width;
        }
    }
    
    frame.origin = CGPointZero;
    [self setFrame:frame];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MXImageBrowser *snackbar = [[MXImageBrowserManager defaultManager] currentMXImageBrowser];
        if (snackbar != nil) {
            [[snackbar imageBrowserView] updateView];
        }
    });
}

- (CGFloat)angleForOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft: {
            return -M_PI_2;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return M_PI_2;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return M_PI;
        }
        default: {
            return 0;
        }
    }
}
@end
