//
//  ViewController.m
//  MXImageBrowser-OC-Demo
//
//  Created by Meniny on 16/7/27.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "ViewController.h"
#import "MXImageBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableArray <NSURL *>*arr = [NSMutableArray array];
    [arr addObject:[NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2525465246,1789307047&fm=80"]];
    [arr addObject:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1469349381,4025225535&fm=80"]];
    [arr addObject:[NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=340374440,3473738723&fm=80"]];
    [[MXImageBrowser browserWithURLs:arr descriptions:nil] show];
    
    [[MXImageBrowser browserWithImages:@[[UIImage imageNamed:@"Detail"], [UIImage imageNamed:@"Logo"]] descriptions:nil] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
