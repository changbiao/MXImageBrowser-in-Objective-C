//
//  MXImageBrowserView.m
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXImageBrowserView.h"
#import "MXPhotoView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MXPlaceHolder.h"
#import "MXImageBrowserButton.h"
#import "MXImageBrowserWindow.h"
#import "UIColor+ImageBrowserColor.h"
#import "MXImageBrowser.h"

const CGFloat kMXNavigationAndStatusBarHeight = 64.000;
const CGFloat kMXStatusBarHeight = 20.000;
const CGFloat kMXNavigationBarHeight = 44.000;
const CGFloat kMXToolBarHeight = 60.000;

@interface MXImageBrowserView ()
@property (nonatomic, strong) UIView * _Nullable navigator;
@property (strong, nonatomic) UIScrollView * _Nonnull contentScrollView;
@property (nonatomic, strong) MXImageBrowserButton * _Nullable shareButton;
@property (nonatomic, assign) BOOL autoScrolled;
@property (nonatomic, strong) UILabel * _Nonnull alertLabel;
@end

@implementation MXImageBrowserView

- (instancetype)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 * @brief 分享按钮被点击
 */
- (void)share {
    NSInteger index = _contentScrollView.contentOffset.x / [_contentScrollView frame].size.width;
    BOOL failed = YES;
    if (self.browser != nil &&
        self.browser.delegate != nil) {
        
        if ([self.browser.delegate respondsToSelector:@selector(imageBrowser:didClickShareWithImage:)]) {
            if ([[[self contentScrollView] subviews] count] > index) {
                UIView *content = [[[self contentScrollView] subviews] objectAtIndex:index];
                for (UIView *sub in [content subviews]) {
                    if ([sub isKindOfClass:[MXPhotoView class]]) {
                        failed = NO;
                        MXPhotoView *photoView = (MXPhotoView *)sub;
                        UIImage *image;
                        if ([photoView image] != nil) {
                            image = [[photoView image] copy];
                        } else {
                            image = [UIImage placeholderImage];
                        }
                        failed = NO;
                        [self.browser.delegate imageBrowser:self.browser didClickShareWithImage:image];
                        
                        //                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                        //                self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
                        //
                        //                if (self.activityViewController != nil) {
                        //                    __weak typeof(self) weakSelf = self;
                        //                    [self.activityViewController setCompletionWithItemsHandler:^(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError) {
                        //
                        //                    }];
                        //                    // iOS 8 - Set the Anchor Point for the popover
                        //                    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
                        //                    //        self.activityViewController.popoverPresentationController.barButtonItem = _actionButton;
                        //                    //    }
                        //                    UIViewController *controller = [[MXImageBrowserWindow defaultWindow] controller];
                        //                    [controller presentViewController:self.activityViewController animated:YES completion:^{
                        
                        //                    }];
                        //                }
                    }
                }
            }
        } else if ([self.browser.delegate respondsToSelector:@selector(imageBrowser:didClickShareWithIndex:)]) {
            failed = NO;
            [self.browser.delegate imageBrowser:self.browser didClickShareWithIndex:index];
        }
    }
    
    if (failed) {
        [self alert:@"保存失败"];
    }
}

//#pragma mark - Save Image Callback
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error == NULL) {
//        [self alert:@"保存成功"];
//    } else {
//        [self alert:@"保存失败"];
//    }
//}

- (void)alert:(NSString *)text {
    [[self alertLabel] setText:text];
    [[self alertLabel] setAlpha:0];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [[weakSelf alertLabel] setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:1.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[weakSelf alertLabel] setAlpha:0];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

/**
 * @brief 初始化图片
 */
- (void)setup {
    self.paths = [NSMutableArray array];
    self.urls = [NSMutableArray array];
    self.images = [NSMutableArray array];
    self.names = [NSMutableArray array];
    self.descriptions = [NSMutableArray array];
    self.sourceType = MXImageBrowserDataSourceTypeXCAssets;
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    [self setContentScrollView:[[UIScrollView alloc] initWithFrame:self.bounds]];
    [[self contentScrollView] setPagingEnabled:YES];
    [[self contentScrollView] setBounces:NO];
    [[self contentScrollView] setShowsVerticalScrollIndicator:NO];
    [[self contentScrollView] setShowsHorizontalScrollIndicator:NO];
    [self addSubview:[self contentScrollView]];
    
    [self setNavigator:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kMXNavigationAndStatusBarHeight)]];
    [self addSubview:[self navigator]];
    
    CGFloat margin = 5;
    CGRect frame = CGRectMake([[self navigator] frame].size.width - margin - kMXNavigationBarHeight,
                              kMXStatusBarHeight,
                              kMXNavigationBarHeight,
                              kMXNavigationBarHeight);
    [self setShareButton:[MXImageBrowserButton circularShadowButtonWithTitle:@""
                                                                       frame:frame
                                                       normalBackgroundColor:[UIColor browserButtonColor]
                                                                    selected:[UIColor browserButtonColor]
                                                            normalTitleColor:[UIColor whiteColor]
                                                          selectedTitleColor:[UIColor whiteColor]
                                                                      target:self
                                                                      action:@selector(share)]];
    [[self shareButton] setImage:[UIImage imageNamed:@"share_browser"] forState:UIControlStateNormal];
    [[self navigator] addSubview:[self shareButton]];
    
    if (!self.allowsShareAction) {
        [[self navigator] setHidden:YES];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
//    [self setAlertLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
//    [[self alertLabel] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
//    [[self alertLabel] setClipsToBounds:YES];
//    [[[self alertLabel] layer] setCornerRadius:3];
//    [[self alertLabel] setAlpha:0];
//    [[self alertLabel] setTextColor:[UIColor whiteColor]];
//    [[self alertLabel] setTextAlignment:NSTextAlignmentCenter];
//    [self addSubview:[self alertLabel]];
}

- (void)setAllowsShareAction:(BOOL)allowsShareAction {
    _allowsShareAction = allowsShareAction;
    if ([self navigator] != nil) {
        [[self navigator] setHidden:!(allowsShareAction)];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.tapActionBlock) {
        self.tapActionBlock();
    }
}

- (void)reload {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf _reload];
    });
}

- (void)_reload {
    for (UIView *subview in [[self contentScrollView] subviews]) {
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i < [self count]; i++) {
        UIView *content = [[UIView alloc] initWithFrame:[self contentViewFrameWithIndex:i]];
        [content setClipsToBounds:YES];
        
        UIImage *image;
        
        switch (self.sourceType) {
            case MXImageBrowserDataSourceTypeWeb: {
//#warning !! WEB
            }
                break;
                
            case MXImageBrowserDataSourceTypeDisk: {
                image = [UIImage imageWithContentsOfFile:[[self paths] objectAtIndex:i]];
            }
                break;
                
            case MXImageBrowserDataSourceTypeXCAssets: {
                image = [UIImage imageNamed:[[self names] objectAtIndex:i]];
            }
                break;
                
            case MXImageBrowserDataSourceTypeUIImages: {
                image = [self.images objectAtIndex:i];
            }
                break;
                
            default:
                break;
        }
        if (image == nil) {
//#warning !! DEFAULT IMAGE
            image = [UIImage placeholderImage];
        }
//        if (!i) {
//            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
//        }
    
        MXPhotoView *photoView = [[MXPhotoView alloc] initWithFrame:content.bounds andImage:image];
        [content addSubview:photoView];
        
        if (self.sourceType == MXImageBrowserDataSourceTypeWeb) {
            NSURL *url = [self.urls objectAtIndex:i];
            [photoView setImageWithURL:url placeholderImage:[UIImage placeholderImage]];
        }
        
        if (self.descriptions != nil && self.descriptions.count) {
            if (i < self.descriptions.count) {
                UIView *toolBarView = [[UIView alloc] init];
                [toolBarView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                [content addSubview:toolBarView];
                
                UILabel *descriptionLabel = [[UILabel alloc] init];
                [descriptionLabel setNumberOfLines:0];
                
                NSString *des = [self.descriptions objectAtIndex:i];
                [descriptionLabel setText:des];
                [descriptionLabel setFont:[UIFont systemFontOfSize:14]];
                [descriptionLabel setTextColor:[UIColor whiteColor]];
                [descriptionLabel setTextAlignment:NSTextAlignmentNatural];
                [toolBarView addSubview:descriptionLabel];
            }
        }
        [self.contentScrollView addSubview:content];
    }
}

- (NSUInteger)count {
    NSInteger count = 0;
    switch (self.sourceType) {
        case MXImageBrowserDataSourceTypeWeb: {
            count = self.urls.count;
        }
            break;
            
        case MXImageBrowserDataSourceTypeDisk: {
            count = self.paths.count;
        }
            break;
            
        case MXImageBrowserDataSourceTypeXCAssets: {
            count = self.names.count;
        }
            break;
            
        case MXImageBrowserDataSourceTypeUIImages: {
            count = self.images.count;
        }
            break;
            
        default:
            break;
    }
    return count;
}

- (CGRect)contentViewFrameWithIndex:(NSUInteger)index {
    return CGRectMake(index * self.contentScrollView.frame.size.width, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
}

- (void)updateView {
    CGSize containerSize = [[MXImageBrowserWindow defaultWindow] frame].size;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown ||
        ![[MXImageBrowserWindow defaultWindow] shouldRotateManually]) {
        width = containerSize.width;
        height = containerSize.height;
    } else {
        width = containerSize.height;
        height = containerSize.width;
    }
    [self setFrame:CGRectMake(x, y, width, height)];
    
    [[self navigator] setFrame:CGRectMake(0, kMXStatusBarHeight, self.bounds.size.width, kMXNavigationAndStatusBarHeight)];
    CGRect frame = [[self shareButton] frame];
    frame.origin.y = ([self navigator].bounds.size.height - frame.size.height) * 0.500;
    frame.origin.x = self.bounds.size.width - frame.size.width - 15;
    [[self shareButton] setFrame:frame];
    
    [[self contentScrollView] setFrame:[self bounds]];
    [[self contentScrollView] setContentSize:CGSizeMake([self contentScrollView].bounds.size.width * [self count], 0)];
    
    [[self alertLabel] setBounds:CGRectMake(0, 0, 120, 50)];
    [[self alertLabel] setCenter:[[self contentScrollView] center]];
    
    for (int i = 0; i < [[[self contentScrollView] subviews] count]; i++) {
        UIView *content = [[[self contentScrollView] subviews] objectAtIndex:i];
        [content setFrame:[self contentViewFrameWithIndex:i]];
        for (UIView *subview in [content subviews]) {
            if ([subview isKindOfClass:[MXPhotoView class]]) {
                [subview setFrame:[content bounds]];
                [(MXPhotoView *)subview setupContentSize];
            } else if ([subview isKindOfClass:[UIView class]]) { // Toolbar
                [subview setFrame:CGRectMake(0, content.frame.size.height - kMXToolBarHeight, content.frame.size.width, kMXToolBarHeight)];
                for (UILabel *label in [subview subviews]) {
                    [label setFrame:CGRectMake(5, 0, subview.frame.size.width - 5 * 2, subview.frame.size.height)];
                }
            }
        }
    }
    
    if (![self autoScrolled]) {
        [self.contentScrollView setContentOffset:CGPointMake([self frame].size.width * self.defaultIndex, 0)];
        [self setAutoScrolled:YES];
    }
}

@end
