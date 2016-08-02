//
//  MXImageBrowser.m
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXImageBrowser.h"
#import "MXImageBrowserManager.h"
#import "MXImageBrowserWindow.h"

NSTimeInterval const kDefaultBrowserDurationInTime = 0.5;
NSTimeInterval const kDefaultBrowserDurationOutTime = 0.5;

@interface MXImageBrowser () {
    BOOL _executing;
    BOOL _finished;
}

@property (nonatomic, copy) MXImageBrowserActionBlock _Nullable clickButtonListener;
@end

@implementation MXImageBrowser

#pragma mark - Initializing
- (void)initializing {
    self.durationIn = 0.25;
    self.durationOut = 0.25;
    __weak typeof(self) weakSelf = self;
    [[self imageBrowserView] setTapActionBlock:^() {
        [weakSelf hide];
    }];
}

- (instancetype)initWithPaths:(NSArray <NSString *> *)paths descriptions:(NSArray <NSString *>*)descriptions {
    self = [super init];
    [self initializing];
    [[self imageBrowserView] setSourceType:MXImageBrowserDataSourceTypeDisk];
    [[[self imageBrowserView] paths] addObjectsFromArray:paths];
    if (descriptions != nil) {
        [[[self imageBrowserView] descriptions] addObjectsFromArray:descriptions];
    }
    return self;
}

- (instancetype)initWithURLs:(NSArray <NSURL *> *)urls descriptions:(NSArray <NSString *>*)descriptions {
    self = [super init];
    [self initializing];
    [[self imageBrowserView] setSourceType:MXImageBrowserDataSourceTypeWeb];
    [[[self imageBrowserView] urls] addObjectsFromArray:urls];
    if (descriptions != nil) {
        [[[self imageBrowserView] descriptions] addObjectsFromArray:descriptions];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images descriptions:(NSArray <NSString *>*)descriptions {
    self = [super init];
    [self initializing];
    [[self imageBrowserView] setSourceType:MXImageBrowserDataSourceTypeUIImages];
    [[[self imageBrowserView] images] addObjectsFromArray:images];
    if (descriptions != nil) {
        [[[self imageBrowserView] descriptions] addObjectsFromArray:descriptions];
    }
    return self;
}

- (instancetype)initWithNames:(NSArray <NSString *> *)names descriptions:(NSArray <NSString *>*)descriptions {
    self = [super init];
    [self initializing];
    [[self imageBrowserView] setSourceType:MXImageBrowserDataSourceTypeXCAssets];
    [[[self imageBrowserView] names] addObjectsFromArray:names];
    if (descriptions != nil) {
        [[[self imageBrowserView] descriptions] addObjectsFromArray:descriptions];
    }
    return self;
}

+ (instancetype)browserWithPaths:(NSArray <NSString *> *)paths descriptions:(NSArray <NSString *>*)descriptions {
    MXImageBrowser *browser = [[MXImageBrowser alloc] initWithPaths:paths descriptions:descriptions];
    return browser;
}

+ (instancetype)browserWithURLs:(NSArray <NSURL *> *)urls descriptions:(NSArray <NSString *>*)descriptions {
    MXImageBrowser *browser = [[MXImageBrowser alloc] initWithURLs:urls descriptions:descriptions];
    return browser;
}

+ (instancetype)browserWithImages:(NSArray <UIImage *> *)images descriptions:(NSArray <NSString *>*)descriptions {
    MXImageBrowser *browser = [[MXImageBrowser alloc] initWithImages:images descriptions:descriptions];
    return browser;
}

+ (instancetype)browserWithNames:(NSArray <NSString *> *)names descriptions:(NSArray <NSString *>*)descriptions {
    MXImageBrowser *browser = [[MXImageBrowser alloc] initWithNames:names descriptions:descriptions];
    return browser;
}

//#pragma mark - Addtion
//- (void)addPaths:(NSMutableArray <NSString *> *)paths {
//    [[self paths] addObjectsFromArray:paths];
//}
//
//- (void)addURLs:(NSMutableArray <NSURL *> *)urls {
//    [[self urls] addObjectsFromArray:urls];
//}
//
//- (void)addImages:(NSMutableArray <UIImage *> *)images {
//    [[self images] addObjectsFromArray:images];
//}
//
//- (void)addNames:(NSMutableArray<NSString *> *)names {
//    [[self names] addObjectsFromArray:names];
//}

- (void)setAllowsShareAction:(BOOL)allowsShareAction {
    [[self imageBrowserView] setAllowsShareAction:allowsShareAction];
}

- (BOOL)allowsShareAction {
    return [[self imageBrowserView] allowsShareAction];
}

#pragma mark - Button Action
- (void)buttonAction {
    if (self.clickButtonListener) {
        self.clickButtonListener(self);
    }
}

#pragma mark - Setter & Getter

- (void)setDefaultIndex:(NSUInteger)defaultIndex {
    [[self imageBrowserView] setDefaultIndex:defaultIndex];
}

- (NSUInteger)defaultIndex {
    return [[self imageBrowserView] defaultIndex];
}

- (void)setDurationIn:(NSTimeInterval)durationIn {
    if (durationIn < kDefaultBrowserDurationInTime) {
        _durationIn = kDefaultBrowserDurationInTime;
    } else {
        _durationIn = durationIn;
    }
}

- (void)setDurationOut:(NSTimeInterval)durationOut {
    if (durationOut < kDefaultBrowserDurationOutTime) {
        _durationOut = kDefaultBrowserDurationOutTime;
    } else {
        _durationOut = durationOut;
    }
}

- (MXImageBrowserView *)imageBrowserView {
    if (_imageBrowserView == nil) {
        _imageBrowserView = [MXImageBrowserView new];
        [_imageBrowserView setBrowser:self];
    }
    return _imageBrowserView;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished {
    return _finished;
}

#pragma mark - Show & Hide
- (void)show {
    [[MXImageBrowserManager defaultManager] addMXImageBrowser:self];
}

- (void)showWithDelegate:(id<MXImageBrowserDelegate> _Nullable)delegate {
    [self setDelegate:delegate];
    [self show];
}

- (void)hide {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect frame = [[weakSelf imageBrowserView] frame];
                             frame.origin.y += frame.size.height;
                             [[weakSelf imageBrowserView] setFrame:frame];
                             [[weakSelf imageBrowserView] setAlpha:0];
                         } completion:^(BOOL finished) {
                             [[weakSelf imageBrowserView] removeFromSuperview];
                             [[MXImageBrowserWindow defaultWindow] setUserInteractionEnabled:NO];
                             [weakSelf finish];
                         }];
    });
}

- (void)start {
    if (![NSThread isMainThread]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf start];
        });
    } else {
        [super start];
    }
}

- (void)main {
    [self setExecuting:YES];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[weakSelf imageBrowserView] reload];
        [[weakSelf imageBrowserView] updateView];
        [[weakSelf imageBrowserView] setAlpha:0];
        [[MXImageBrowserWindow defaultWindow] addSubview:[weakSelf imageBrowserView]];
        [[MXImageBrowserWindow defaultWindow] setUserInteractionEnabled:YES];
        CGRect frame = [[weakSelf imageBrowserView] frame];
        frame.origin.y += frame.size.height;
        [[weakSelf imageBrowserView] setFrame:frame];
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect frame = [[weakSelf imageBrowserView] frame];
                             frame.origin.y -= frame.size.height;
                             [[weakSelf imageBrowserView] setFrame:frame];
                             [[weakSelf imageBrowserView] setAlpha:1];
                         } completion:^(BOOL finished) {
                             
                         }];
    });
}

- (void)cancel {
    [super cancel];
    [self finish];
}

- (void)finish {
    [[self imageBrowserView] removeFromSuperview];
    [[self imageBrowserView] setBrowser:nil];
    [self setDelegate:nil];
    [self setExecuting:NO];
    [self setFinished:YES];
}
@end
