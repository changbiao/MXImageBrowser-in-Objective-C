//
//  MXImageBrowser.h
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/26.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MXImageBrowserView.h"

@class MXImageBrowser;
typedef void (^MXImageBrowserActionBlock) (MXImageBrowser * _Nonnull snackbar);

@interface MXImageBrowser : NSOperation
/**
 * @brief 显示用时
 */
@property (nonatomic, assign) NSTimeInterval durationIn;
/**
 * @brief 隐藏用时
 */
@property (nonatomic, assign) NSTimeInterval durationOut;

@property (nonatomic, strong) MXImageBrowserView * _Nonnull imageBrowserView;

- (instancetype _Nonnull)initWithImages:(NSArray <UIImage *> * _Nonnull)images descriptions:(NSArray <NSString *>* _Nullable)descriptions;
- (instancetype _Nonnull)initWithPaths:(NSArray <NSString *> * _Nonnull)paths descriptions:(NSArray <NSString *>* _Nullable)descriptions;
- (instancetype _Nonnull)initWithURLs:(NSArray <NSURL *> * _Nonnull)urls descriptions:(NSArray <NSString *>* _Nullable)descriptions;
- (instancetype _Nonnull)initWithNames:(NSArray <NSString *> * _Nonnull)names descriptions:(NSArray <NSString *>* _Nullable)descriptions;

+ (instancetype _Nonnull)browserWithImages:(NSArray <UIImage *> * _Nonnull)images descriptions:(NSArray <NSString *>* _Nullable)descriptions;
+ (instancetype _Nonnull)browserWithPaths:(NSArray <NSString *> * _Nonnull)paths descriptions:(NSArray <NSString *>* _Nullable)descriptions;
+ (instancetype _Nonnull)browserWithURLs:(NSArray <NSURL *> * _Nonnull)urls descriptions:(NSArray <NSString *>* _Nullable)descriptions;
+ (instancetype _Nonnull)browserWithNames:(NSArray <NSString *> * _Nonnull)names descriptions:(NSArray <NSString *>* _Nullable)descriptions;

//- (void)addImages:(NSMutableArray <UIImage *> *)images;
//- (void)addPaths:(NSMutableArray <NSString *> *)paths;
//- (void)addURLs:(NSMutableArray <NSURL *> *)urls;
//- (void)addNames:(NSMutableArray <NSString *> *)names;

/**
 *  Show MXImageBrowser
 */
- (void)show;
/**
 *  Hide MXImageBrowser
 */
- (void)hide;
@end
