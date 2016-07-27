//
//  MXImageBrowserManager.h
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MXImageBrowser.h"

@interface MXImageBrowserManager : NSObject
+ (instancetype _Nonnull)defaultManager;
- (void)addMXImageBrowser:(MXImageBrowser * _Nullable)snackbar;
- (MXImageBrowser * _Nullable)currentMXImageBrowser;
- (void)cancelAllMXImageBrowser;
@end
