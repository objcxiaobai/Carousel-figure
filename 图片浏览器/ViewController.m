//
//  ViewController.m
//  图片浏览器
//
//  Created by 冼 on 2018/4/15.
//  Copyright © 2018年 Null. All rights reserved.
//

#import "ViewController.h"
#import "Bnnner.h"
@interface ViewController ()

@property (nonatomic,strong) Bnnner *bnner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *urls = @[
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=7844b6536559252da3424e4452a63709/4b90f603738da97798afd262b551f8198718e3f3.jpg",
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=2fbe89b579d98d1076815f7147028c3c/f603918fa0ec08fa505e0cee5cee3d6d55fbda18.jpg",
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=e5d0477f18950a7b75601d846cec56eb/0ff41bd5ad6eddc4f802a8b23cdbb6fd53663395.jpg",
                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=88b9154b8244ebf86d24377fbfc4e318/42a98226cffc1e17695ba0794f90f603728de996.jpg"];
    
    self.bnner = [[Bnnner alloc] initWithPhotosDate:urls];
    
    [self.view addSubview:self.bnner];
    
    [self.bnner mas_makeConstraints:^(MASConstraintMaker *make) {
       //这里得到宽
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.bnner.mas_width).multipliedBy(260/425.f);
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
