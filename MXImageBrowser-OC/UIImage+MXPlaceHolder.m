//
//  UIImage+MXPlaceHolder.m
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "UIImage+MXPlaceHolder.h"

@implementation UIImage (MXPlaceHolder)
+ (UIImage *)placeholderImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, [UIScreen mainScreen].scale);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}
@end
