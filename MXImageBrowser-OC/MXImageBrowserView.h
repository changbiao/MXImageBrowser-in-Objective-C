//
//  MXImageBrowserView.h
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 浏览器数据源类型
 */
typedef NS_OPTIONS(NSInteger, MXImageBrowserDataSourceType) {
    /**
     * @brief 网络图片
     */
    MXImageBrowserDataSourceTypeWeb = 1 << 0,
    /**
     * @brief 磁盘图片
     */
    MXImageBrowserDataSourceTypeDisk = 1 << 1,
    /**
     * @brief XCAssets图片
     */
    MXImageBrowserDataSourceTypeXCAssets = 1 << 2,
    /**
     * @brief UIImage对象
     */
    MXImageBrowserDataSourceTypeUIImages = 1 << 3
};

typedef void (^TapAction)(void);

@class MXImageBrowser;

@interface MXImageBrowserView : UIView
@property (nonatomic, strong) MXImageBrowser * _Nullable browser;
/**
 * @brief 数据源，内容为UIImage对象
 */
@property (nonatomic, strong) NSMutableArray <UIImage *> * _Nonnull images;
/**
 * @brief 数据源，内容为磁盘图片路径
 */
@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull paths;
/**
 * @brief 数据源，内容为网络图片地址
 */
@property (nonatomic, strong) NSMutableArray <NSURL *> * _Nonnull urls;
/**
 * @brief 数据源，内容为图片名
 */
@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull names;
/**
 * @brief 图片描述
 */
@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull descriptions;
/**
 * @brief 数据源类型
 */
@property (nonatomic, assign) MXImageBrowserDataSourceType sourceType;
/**
 *  是否显示分享按钮
 */
@property (nonatomic, assign) BOOL allowsShareAction;
/**
 * @brief 默认图片索引
 */
@property (nonatomic, assign) NSUInteger defaultIndex;

@property (nonatomic, copy) TapAction _Nullable tapActionBlock;

- (void)reload;
- (void)updateView;
@end
