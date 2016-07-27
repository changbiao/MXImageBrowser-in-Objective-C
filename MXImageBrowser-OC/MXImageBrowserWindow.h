//
//  MXImageBrowserWindow.h
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXImageBrowserWindow : UIWindow
@property (nonatomic, strong) UIViewController * _Nonnull controller;
+ (instancetype _Nonnull)defaultWindow;
- (BOOL)shouldRotateManually;
@end
