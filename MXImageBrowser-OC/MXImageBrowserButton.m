//
//  MXImageBrowserButton.m
//  UIDemo
//
//  Created by Meniny on 16/3/7.
//  Copyright © 2016年 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXImageBrowserButton.h"
#import "UIColor+ImageBrowserColor.h"

CGFloat const kMXNavigatorTextSize = 13;

@implementation MXImageBrowserButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {
//    [self.layer setCornerRadius:0];
    _normalColor = [UIColor whiteColor];
    _selectedColor = [UIColor browserButtonColor];
    _normalTitleColor = [UIColor browserButtonColor];
    _selectedTitleColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];//is must to ensure rightly layout children view
    CGColorRef color = !self.selected ? self.normalColor.CGColor : self.selectedColor.CGColor;
        
        if (self.innerView == nil) {
            //1. first, create Inner layer with content
            CALayer *innerView = [CALayer layer];
            innerView.frame = self.bounds;
            //instead of: innerView.frame = self.frame;
            //            innerView.borderWidth = 1.0f;
            innerView.cornerRadius = self.layer.cornerRadius;
            innerView.masksToBounds = YES;
            //            innerView.borderColor = [[UIColor lightGrayColor] CGColor];
            //put the layer to the BOTTOM of layers is also a MUST step...
            //otherwise this layer will overlay the sub uiviews in current uiview...
            [innerView setBackgroundColor:color];
            self.innerView = innerView;
            [self.layer insertSublayer:self.innerView atIndex:0];
            
            //2. then, create shadow with self layer
            self.layer.masksToBounds = NO;
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOpacity = 0.2f;
            //shadow length
            self.layer.shadowRadius = 1.5f;
            //no offset
            self.layer.shadowOffset = CGSizeMake(0, 2);
            //right down shadow
            //[self.layer setShadowOffset: CGSizeMake(1.0f, 1.0f)];
            
            //3. last but important, MUST clear current view background color, or the color will show in the corner!
            self.backgroundColor = [UIColor clearColor];
            //    } else {
            //        self.innerView.frame = self.bounds;
            //        self.innerView.cornerRadius = self.layer.cornerRadius;
        }
    [self.innerView setBackgroundColor:color];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self setNeedsDisplay];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self setNeedsDisplay];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    _normalTitleColor = normalTitleColor;
    [self setTitleColor:_normalTitleColor forState:UIControlStateNormal];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    [self setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}
+ (instancetype)circularShadowButtonWithTitle:(NSString *)title
                                                    frame:(CGRect)frame
                                    normalBackgroundColor:(UIColor *)nomalColor
                                                 selected:(UIColor *)selectedColor
                                         normalTitleColor:(UIColor *)normalTitleColor
                                       selectedTitleColor:(UIColor *)selectedTitleColor
                                                   target:(id)target
                                                   action:(SEL)aSelector {
    MXImageBrowserButton *item = [MXImageBrowserButton circularShadowButtonWithFrame:frame
                                                   normalBackgroundColor:nomalColor
                                                                selected:selectedColor
                                                        normalTitleColor:normalTitleColor
                                                      selectedTitleColor:selectedTitleColor
                                                                  target:target
                                                                  action:aSelector];
    if (title != nil) {
        [item setTitle:title forState:UIControlStateNormal];
    }
    return item;
}

+ (instancetype)circularShadowButtonWithFrame:(CGRect)frame
                                    normalBackgroundColor:(UIColor *)nomalColor
                                                 selected:(UIColor *)selectedColor
                                         normalTitleColor:(UIColor *)normalTitleColor
                                       selectedTitleColor:(UIColor *)selectedTitleColor
                                                   target:(id)target
                                                   action:(SEL)aSelector {
    MXImageBrowserButton *item = [[MXImageBrowserButton alloc] initWithFrame:frame];
    [item setNormalColor:nomalColor];
    [item setSelectedColor:selectedColor];
    [item setNormalTitleColor:normalTitleColor];
    [item setSelectedTitleColor:selectedTitleColor];
    [item.titleLabel setNumberOfLines:0];
    item.layer.cornerRadius = [item frame].size.width * 0.5;
    item.clipsToBounds = YES;
    [[item titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [item.titleLabel setFont:[UIFont systemFontOfSize:kMXNavigatorTextSize]];
    [item addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    return item;
}

@end
