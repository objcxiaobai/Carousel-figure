//
//  Bnnner.m
//  图片浏览器
//
//  Created by 冼 on 2018/4/15.
//  Copyright © 2018年 Null. All rights reserved.
//

#import "Bnnner.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface Bnnner(){
    //当前图片索引
    NSInteger _currentImageIndex;
    //图片总数
    NSInteger _imageCount;
    
}

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIView *contentview;
//逻辑思路：3，1，2，3，1
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
//
@property (nonatomic,strong) UIPageControl *pageContrl;
//图片数据
@property (nonatomic,strong) NSMutableArray *arrays;


@property (nonatomic,strong) NSTimer *timer;

@end
@implementation Bnnner


#pragma mark -- 代理方法

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollview setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    //设置分页
    _pageContrl.currentPage = _currentImageIndex;
    
    [self addTimer];
}


#pragma mark --初始化
-(instancetype)initWithPhotosDate:(NSArray *)arrys{
    if (self = [super init]) {
        
        self.arrays = [NSMutableArray arrayWithArray:arrys];
        _imageCount = self.arrays.count;
        [self initUI];
    }
    return self;
}

//控件初始化
-(void)initUI{
    [self addSubview:self.scrollview];
    
    //使用这个方便过度
    self.contentview = UIView.new;
    [self.scrollview addSubview:self.contentview];
    //创建3个图片
    [self.contentview addSubview:self.leftImageView];
    [self.contentview addSubview:self.centerImageView];
    [self.contentview addSubview:self.rightImageView];
    
    
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self).offset(0);
        
    }];
    
    [self.contentview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.scrollview);
        make.height.equalTo(self.scrollview);
        
    }];

    //开始布局
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentview.mas_left).offset(0);
        make.top.equalTo(self.contentview).offset(0);
        make.centerY.equalTo(self.contentview);
        //设宽度
        make.width.equalTo(self.scrollview.mas_width);
        
    }];
    
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right);
        make.top.equalTo(self.contentview).offset(0);
        make.centerY.equalTo(self.contentview);
        //设宽度
        make.width.equalTo(self.scrollview.mas_width);
        
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.centerImageView.mas_right);
        make.top.equalTo(self.contentview).offset(0);
        make.centerY.equalTo(self.contentview);
        //设宽度
        make.width.equalTo(self.scrollview.mas_width);
    }];
    
    
    /**重要一步**/
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.rightImageView.mas_right);
    }];
    
    
    //添加page
    [self addSubview:self.pageContrl];
    
    //page位置,不要添加到contentview上
    [_pageContrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        
    }];
    
    //判断位置是否存在
    if(self.arrays.count > 0){
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[_imageCount -1]]];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays.firstObject]];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[1]]];
    }
    
    //初始化下标.
    _currentImageIndex = 0;
    //默认为0；
    _pageContrl.currentPage = _currentImageIndex;
    
    [self addTimer];
}

#pragma mark 重新加载图片
-(void)reloadImage{
    
  
    
    NSInteger leftImageindx, rightImgeIndex;
    //拿到当前位置
    CGPoint offset = [_scrollview contentOffset];
    //向右滑动
    if (offset.x >kScreenWidth) {
        
        _currentImageIndex = (_currentImageIndex + 1) % _imageCount;
    //向左滑动
    }else if (offset.x < kScreenWidth){
        
        _currentImageIndex = (_currentImageIndex + _imageCount -1) % _imageCount;
    }
    
    
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[_currentImageIndex]]];
    
    //重新设置左右图片
    leftImageindx = (_currentImageIndex + _imageCount -1) %_imageCount;
    rightImgeIndex = (_currentImageIndex +1) %_imageCount;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[leftImageindx]]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[rightImgeIndex]]];
    
    
    
}
/*
 *定时器
 */
-(void)addTimer{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/*
 *自动播放
 */
-(void)nextImage{
    
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[_currentImageIndex]]];

    NSInteger leftImageIndex,rightimageIndex;
    leftImageIndex = (_currentImageIndex + _imageCount -1)%_imageCount;
    rightimageIndex = (_currentImageIndex + 1) %_imageCount;

    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[leftImageIndex]]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.arrays[rightimageIndex]]];

    self.pageContrl.currentPage = _currentImageIndex;

    if (_currentImageIndex == 3) {

        _currentImageIndex = 0;
    }
    else{
        _currentImageIndex++;
    }

    

    
}


#pragma marke -懒加载
-(UIScrollView *)scrollview{
    if (!_scrollview) {
        
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.delegate = self;
        _scrollview.bounces = NO;
        //设置分页
        _scrollview.pagingEnabled = YES;
        //去掉滚动条
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = YES;
        
    }
    
    return _scrollview;
    
    
}
-(UIImageView *)leftImageView{
    
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _leftImageView;
}
-(UIImageView *)centerImageView{
    
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerImageView;
}
-(UIImageView *)rightImageView{
    
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
    
}
-(UIPageControl *)pageContrl{
    if (!_pageContrl) {
        
        _pageContrl = [[UIPageControl alloc] init];
        //设置颜色
        _pageContrl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
        //设置当前页颜色
        _pageContrl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
        _pageContrl.numberOfPages = _imageCount;

        
        
    }
    return _pageContrl;
}

@end
