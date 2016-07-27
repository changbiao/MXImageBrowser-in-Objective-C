//
//  MXImageBrowserButton.h
//  UIDemo
//
//  Created by Meniny on 16/3/7.
//  Copyright © 2016年 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <UIKit/UIKit.h>

@interface MXImageBrowserButton : UIButton
@property (weak, nonatomic) CALayer *innerView;
@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *normalTitleColor;
@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;

+ (instancetype)circularShadowButtonWithTitle:(NSString *)title
                                                    frame:(CGRect)frame
                                    normalBackgroundColor:(UIColor *)nomalColor
                                                 selected:(UIColor *)selectedColor
                                         normalTitleColor:(UIColor *)normalTitleColor
                                       selectedTitleColor:(UIColor *)selectedTitleColor
                                                   target:(id)target
                                                   action:(SEL)aSelector;

//+ (instancetype)circularShadowButtonWithTitle:(NSString *)title
//                                        frame:(CGRect)frame
//                        normalBackgroundColor:(UIColor *)nomalColor
//                                     selected:(UIColor *)selectedColor
//                             normalTitleColor:(UIColor *)normalTitleColor
//                           selectedTitleColor:(UIColor *)selectedTitleColor
//                                       target:(id)target
//                                       action:(SEL)aSelector;

+ (instancetype)circularShadowButtonWithFrame:(CGRect)frame
                        normalBackgroundColor:(UIColor *)nomalColor
                                     selected:(UIColor *)selectedColor
                             normalTitleColor:(UIColor *)normalTitleColor
                           selectedTitleColor:(UIColor *)selectedTitleColor
                                       target:(id)target
                                       action:(SEL)aSelector;
@end
