//
//  MXImageBrowserManager.m
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXImageBrowserManager.h"

@interface MXImageBrowserManager ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation MXImageBrowserManager

#pragma mark - Allocation
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)defaultManager {
    static MXImageBrowserManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MXImageBrowserManager new];
    });
    return instance;
}

#pragma mark - Getter & Setter

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [NSOperationQueue new];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return _queue;
}

- (MXImageBrowser *)currentMXImageBrowser {
    if ([[self queue] operationCount]) {
        return (MXImageBrowser *)[[[self queue] operations] firstObject];
    }
    return nil;
}

#pragma mark - Actions

- (void)addMXImageBrowser:(MXImageBrowser *)snackbar {
    if (snackbar != nil) {
        [[self queue] addOperation:snackbar];
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    if ([[self queue] operationCount]) {
        MXImageBrowser *lastMXImageBrowser = (MXImageBrowser *)[[[self queue] operations] firstObject];
        if ([lastMXImageBrowser imageBrowserView] != nil) {
            [[lastMXImageBrowser imageBrowserView] updateView];
        }
    }
}

- (void)cancelAllMXImageBrowser {
    for (MXImageBrowser *snackbar in [[self queue] operations]) {
        [snackbar cancel];
    }
}
@end
