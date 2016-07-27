//
//  MXImageBrowser.m
//  MXPhotosBrowser
//
//    ／￣￣￣Y￣￣。 ＼
//   l　　　　　　　　　l
//　ヽ,,,,,／ ￣￣￣￣ ヽﾉ
//　|::::: 　　　　　　　l
//　|:::　　 ＿_　　　　 |
//（6　　　＼●　     ●  丨
//　!　　　　  )・・(    ﾉ
//　ヽ 　 　　　(三)　  ﾉ
//　／＼　   　  二　ノ
// /⌒ヽ. ‘ー — 一 ＼
//l　　　 |👍🏻　　　ヽoヽ👍🏻
//
//  Created by Meniny on 16/4/23.
//  Copyright © 2016年 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXPhotoView.h"
#import "UIImageView+WebCache.h"

@interface UIImage (MXUtils)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (MXUtils)

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (MXUtils)

- (CGSize)contentSize;

@end

@implementation UIImageView (MXUtils)

- (CGSize)contentSize {
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface MXPhotoView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;

@end

@implementation MXPhotoView


- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.delegate = self;
        self.bouncesZoom = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        // Add container view
        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
        containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:containerView];
        _containerView = containerView;
        
        [self setMaxMinZoomScale];
        
        // Add image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
        [self.containerView addSubview:imageView];
        
        [self setImage:image];
        
        // Setup other events
        [self setupGestureRecognizer];
//        [self setupRotationNotification];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (image == nil) {
            [_imageView setImage:image];
        } else {
            [_imageView setImage:[image copy]];
        }
        [weakSelf setupContentSize];
    });
}

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage {
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf setImage:[image copy]];
            });
        }
    }];
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setupContentSize {
    // Fit container view's size to image size
    CGSize imageSize;
    if (_imageView.image == nil) {
        imageSize = CGSizeZero;
    } else {
        CGFloat width = 0;
        CGFloat height = 0;
        if ([self frame].size.width < [self frame].size.height) {
            width = [self frame].size.width;
            height = _imageView.image.size.height / (_imageView.image.size.width / [self frame].size.width);
        } else {
            if ([self imageView].image.size.width <= [self imageView].image.size.height) {
                width = [self frame].size.width;
                height = _imageView.image.size.width / (_imageView.image.size.height / [self frame].size.height);
            } else {
                width = [self frame].size.width;
                height = _imageView.image.size.height / (_imageView.image.size.width / [self frame].size.width);
            }
        }
        
        imageSize = CGSizeMake(width, height);
    }
    self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
    
    self.contentSize = imageSize;
    self.minSize = imageSize;
    
    // Center containerView by set insets
    [self centerContent];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.rotating) {
        self.rotating = NO;
        
        // update container view frame
        CGSize containerSize = self.containerView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [self.imageView.image sizeThatFits:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale) { // 宽度或高度 都小于 self 的宽度和高度
            self.zoomScale = minZoomScale;
        }
        
        // Center container view
        [self centerContent];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupRotationNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:doubleTapGestureRecognizer];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)doubleTapHandler:(UITapGestureRecognizer *)recognizer {
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else if (self.zoomScale < self.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect) * 0.5, location.y - CGRectGetHeight(zoomToRect)/2);
        [self zoomToRect:zoomToRect animated:YES];
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification {
    self.rotating = YES;
}

#pragma mark - Helper

- (void)setMaxMinZoomScale {
//    CGSize imageSize = self.imageView.image.size;
//    CGSize imagePresentationSize = self.imageView.contentSize;
//    CGFloat maxScale = MAX(imageSize.height / imagePresentationSize.height, imageSize.width / imagePresentationSize.width);
    self.maximumZoomScale = 10.0;//MAX(10, maxScale); // Should not less than 1
    self.minimumZoomScale = 1.0;
}

- (void)centerContent {
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

@end