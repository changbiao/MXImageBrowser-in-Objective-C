# MXImageBrowser-in-Objective-C

`MXImageBrowser` is a custom alert view.

## Installation with CocoaPods

```
pod 'MXImageBrowser'
```

## Usage

```
#import "MXImageBrowser.h"
```

Sample Code:

```
NSMutableArray <NSURL *>*arr = [NSMutableArray array];
[arr addObject:[NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2525465246,1789307047&fm=80"]];
[arr addObject:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1469349381,4025225535&fm=80"]];
[arr addObject:[NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=340374440,3473738723&fm=80"]];
[[MXImageBrowser browserWithURLs:arr descriptions:nil] show];
```

```
[[MXImageBrowser browserWithImages:@[[UIImage imageNamed:@"Detail"], [UIImage imageNamed:@"Logo"]] descriptions:nil] show];
```

```
MXImageBrowser *browser = [MXImageBrowser browserWithImages:@[[UIImage imageNamed:@"Detail"], [UIImage imageNamed:@"Logo"]] descriptions:nil];
// Since 3.0.0:
[browser setAllowsShareAction:YES];
[browser showWithDelegate:self];
```
