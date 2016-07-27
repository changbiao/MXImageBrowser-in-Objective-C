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

#import <UIKit/UIKit.h>

@interface MXPhotoView : UIScrollView
- (void)setImage:(UIImage *)image;
- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (UIImage *)image;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
- (void)setupContentSize;
@end
