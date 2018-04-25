//
//  CQCycleScrollView.m
//  testCycleScrollView
//
//  Created by CoderQi on 2018/4/23.
//  Copyright © 2018年 CoderQi. All rights reserved.
//

#import "CQCycleScrollView.h"
#import "UIView+CQExtension.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"

const NSString  *ID = @"CQCycleScrollViewCell";
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeigh ([uiscreen mainScreen].bounds.size.height)

@interface CQCycleScrollView()<UIScrollViewDelegate>

//--------------------------------      数据相关      ------------------------------------//
@property(nonatomic, strong)NSArray *imagePathsGroup;//image缓存数组
@property(nonatomic, strong)NSTimer *timer;//滚动计时器
@property(nonatomic, strong)UIImage *backgroundImage; // 当imageURLs为空时的背景图
@property(nonatomic, assign)CGFloat gapDis;//视图差别程度 默认为10
@property(nonatomic, assign)NSInteger effectCount;//有效的轮播个数
@property(nonatomic, assign)CGFloat picSpace;//banner之间的间距
@property(nonatomic, assign)CGFloat oldOffX;//原先的X偏移量，为判断出滑动方向
@property(nonatomic, assign)NSInteger oldIndex;

//--------------------------------      控件相关      ------------------------------------//
@property(nonatomic, strong)UIControl *pageControl;//页码控制器
@property(nonatomic, strong)UIScrollView *mainScrollView;//主轮播视图
@property(nonatomic, strong)UILabel *titleLabelView;//标题展示视图
@property(nonatomic, strong)NSMutableArray *imageViews;

@end

@implementation CQCycleScrollView


#pragma mark -----用户界面的初始化
- (void)setupUIView
{
    [self addImageViewToScrollView];
    
    [self makeScrollViewScrollToIndex:0];
    
    [self setupTimer];
}
/***   给scrollView添加图片  ***/
-(void)addImageViewToScrollView{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.scrollEnabled = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    NSInteger count = self.imageUrlStringGroup.count < self.titleGroup.count ? self.imageUrlStringGroup.count : self.titleGroup.count;
    _effectCount = count;
    CGFloat fWidth = self.frame.size.width;
    CGFloat fHeight = self.frame.size.height;
    CGFloat picWidth = fWidth - _picSpace*2 *2 -_picSpace *2;
    CGFloat picHeight = fHeight - _gapDis * 2;
    _mainScrollView.contentSize = CGSizeMake((count+2) * (picWidth+_picSpace) + _gapDis *2, self.frame.size.height);
    [self addSubview:_mainScrollView];
    //如果有数据，则进行视图的创建
    if (count > 0) {
        _imageViews = [NSMutableArray array];
        /***   进行视图添加  ***/
        //创建头图片
        NSString *lastImageUrl = [_imageUrlStringGroup objectAtIndex:count-1];
        UIImageView *firstImageView = [[UIImageView alloc]init];
        [firstImageView setImageWithURL:[NSURL URLWithString:lastImageUrl] placeholderImage:_backgroundImage];
        [_mainScrollView addSubview:firstImageView];
        [firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@0);
            //            make.centerY.mas_equalTo(self.frame.size.height/2);
            make.top.mas_equalTo(self.gapDis);
            make.width.mas_equalTo(picWidth);
            make.height.mas_equalTo(picHeight);
        }];
        UILabel *firstLabel = [[UILabel alloc]init];
        firstLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        firstLabel.font = [UIFont systemFontOfSize:10];
        firstLabel.layer.masksToBounds = YES;
        firstLabel.layer.cornerRadius = 3;
        firstLabel.textColor = [UIColor whiteColor];
        firstLabel.text = _titleGroup[_effectCount-1];
        [_imageViews addObject:firstImageView];
        [firstImageView addSubview:firstLabel];
        [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(firstImageView.mas_bottom);
            make.left.mas_equalTo(firstImageView.mas_left).mas_offset(10);
            make.width.mas_equalTo(firstImageView.mas_width);
            make.height.mas_equalTo(@20);
        }];
        
        //创建中间图片
        for (int i = 0 ; i < count; i++) {
            NSString *imageUrl = _imageUrlStringGroup[i];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:_backgroundImage];
            [_mainScrollView addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
        
        //创建尾图片
        NSString *firstImageUrl = _imageUrlStringGroup.firstObject;
        UIImageView *lastImageView = [[UIImageView alloc]init];
        [lastImageView setImageWithURL:[NSURL URLWithString:firstImageUrl] placeholderImage:_backgroundImage];
        [_mainScrollView addSubview:lastImageView];
        [_imageViews addObject:lastImageView];
        UIImageView *frontView = _imageViews[_imageViews.count-2];
        [lastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(frontView.mas_right).offset(self.picSpace);
            make.centerY.mas_equalTo(firstImageView.mas_centerY);
            make.width.mas_equalTo(picWidth);
            make.height.mas_equalTo(picHeight);
        }];
        UILabel *lastLabel = [[UILabel alloc]init];
        lastLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        lastLabel.font = [UIFont systemFontOfSize:10];
        lastLabel.layer.masksToBounds = YES;
        lastLabel.layer.cornerRadius = 3;
        lastLabel.text = _titleGroup[0];
        lastLabel.textColor = [UIColor whiteColor];
        [lastImageView addSubview:lastLabel];
        [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lastImageView.mas_bottom);
            make.left.mas_equalTo(lastImageView.mas_left).mas_offset(10);
            make.width.mas_equalTo(lastImageView.mas_width);
            make.height.mas_equalTo(@20);
        }];
        
        for (int i = 1; i < self.imageViews.count; i++) {
            UIImageView *imageView = self.imageViews[i];
            //设置约束
            if(i == 1){
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(firstImageView.mas_right).offset(self.picSpace);
                    make.centerY.mas_equalTo(firstImageView.mas_centerY);
                    make.width.mas_equalTo(picWidth);
                    make.height.mas_equalTo(picHeight);
                }];
            }else{
                if (_imageViews == nil) {
                    continue;
                }
                UIImageView *frontView = _imageViews[i-1];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(frontView.mas_right).offset(self.picSpace);
                    make.centerY.mas_equalTo(firstImageView.mas_centerY);
                    make.width.mas_equalTo(picWidth);
                    make.height.mas_equalTo(picHeight);
                }];
            }
            if (i < self.imageViews.count-1) {
                UILabel *normalLabel = [[UILabel alloc]init];
                normalLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                normalLabel.font = [UIFont systemFontOfSize:10];
                normalLabel.layer.masksToBounds = YES;
                normalLabel.layer.cornerRadius = 3;
                normalLabel.text = _titleGroup[i-1];
                normalLabel.textColor = [UIColor whiteColor];
                [imageView addSubview:normalLabel];
                [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(imageView.mas_bottom);
                    make.left.mas_equalTo(imageView.mas_left).mas_offset(10);
                    make.width.mas_equalTo(imageView.mas_width);
                    make.height.mas_equalTo(@20);
                }];
            }
        }
    }
    
    //给每个视图添加圆角和响应事件
    for (UIImageView *imageView in self.imageViews) {
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        imageView.userInteractionEnabled = YES;
    }
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup
{
    CQCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.localImageNameGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleScrollView;
}

#pragma mark -----逻辑处理事件
/***   将试图移到指定位置  ***/
- (void)makeScrollViewScrollToIndex:(NSInteger)index{
    
    CGFloat fWidth = self.frame.size.width;
    CGFloat fHeight = self.frame.size.height;
    CGFloat picWidth = fWidth - _picSpace*2 *2 -_picSpace *2;
    CGFloat picHeight = fHeight - _gapDis * 2;
    
    CGFloat xDistance = (picWidth + _picSpace) * (index+1) - 2*_picSpace;
    if(_oldIndex > index){
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }
    [UIView animateWithDuration:1 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(xDistance, 0);
    }];
    [UIView animateWithDuration:_autoScrollTime animations:^{
        //    改变旧目标大小
        UIImageView *imageViewOld = self.imageViews[self.oldIndex+1];
        if (imageViewOld) {
            [imageViewOld mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(picHeight);
                make.width.mas_equalTo(picWidth);
            }];
        }
        //    改变新目标大小
        UIImageView *imageViewNew = self.imageViews[index+1];
        if (imageViewNew) {
            [imageViewNew mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(picHeight + self.gapDis);
                make.width.mas_equalTo(picWidth + self.gapDis);
            }];
        }
    }];

    _oldIndex = index;
}

#pragma mark -----定时器相关
- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTime target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)automaticScroll{
    if (_effectCount == 0) {
        return ;
    }
    NSInteger aimIndex = _oldIndex;
    if (_oldIndex == _effectCount-1) {
        _oldOffX = -100;
        aimIndex = 0;
    }else{
        aimIndex++;
    }
    
    [self makeScrollViewScrollToIndex:aimIndex];
}

#pragma mark -----代理事件处理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat fWidth = self.frame.size.width;
    CGFloat picWidth = fWidth - _picSpace*2 * 2 -_picSpace *2;

    if(offSetX < _oldOffX){
        //判断到达前面边界
        CGFloat disF = offSetX - (picWidth -  2 * _picSpace);
        if( disF < 20 && disF > 0){
            [self makeScrollViewScrollToIndex:_effectCount];
        }
    }else{
        //判断到达后面边界
        CGFloat disB = offSetX - (_effectCount * (picWidth+_picSpace)+ _gapDis *2);
        if(disB < 20 && disB > 0){
            _oldOffX = -100;
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
            return;
        }
    }
    _oldOffX = offSetX;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat fWidth = self.frame.size.width;
    CGFloat picWidth = fWidth - _picSpace*2 * 2 -_picSpace *2;
    NSInteger index = (offSetX + kScreenWidth/2 ) / (picWidth + _picSpace);
    [self makeScrollViewScrollToIndex:index-1];
}

#pragma mark -----初始化属性赋值处理
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<CQCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage{
    CQCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.backgroundImage = placeholderImage;
    return cycleScrollView;
}

- (void)initialization
{
    _pageControlAliment = CQCycleScrollViewPageContolAlignmentCenter;
    _autoScrollTime = 3.0;
    _infiniteLoop = YES;
    _showPageControl = YES;
    _gapDis = 30;
    _picSpace = _gapDis/2;
    _oldIndex = 0;
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor lightGrayColor];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupUIView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupUIView];
}

-(void)setImageUrlStringGroup:(NSArray *)imageUrlStringGroup{
    _imageUrlStringGroup = imageUrlStringGroup;
    if (self.imageViews == nil) {
        [self setupUIView];
    }
}

-(void)setTitleGroup:(NSArray *)titleGroup{
    _titleGroup = titleGroup;
    if (self.imageViews == nil) {
        [self setupUIView];
    }
}
@end




























