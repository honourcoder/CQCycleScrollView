//
//  CQCycleScrollView.h
//  testCycleScrollView
//
//  Created by CoderQi on 2018/4/23.
//  Copyright © 2018年 CoderQi. All rights reserved.
//

#import <UIKit/UIKit.h>


/***   pagecontroll文字显示位置设置  ***/
typedef enum {
    CQCycleScrollViewPageContolAlignmentRight,
    CQCycleScrollViewPageContolAlignmentCenter,
    CQCycleScrollViewPageContolAlignmentLeft,
} CQCycleScrollViewPageContolAlignment;


#pragma mark -----CQCycleScrollViewDelegate相关

@class CQCycleScrollView;

@protocol CQCycleScrollViewDelegate<NSObject>

/***   点击图片回调  ***/
-(void)cqCycleScrollView:(CQCycleScrollView *)cycleScrollView didSelectItemIndex:(NSInteger)index;
/***   图片滚动回调  ***/
-(void)cqCycleScrollView:(CQCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end



#pragma mark -----CQCycleScrollView相关

@interface CQCycleScrollView : UIView


//--------------------------------      数据源相关API      ------------------------------------//
/***   网络图片URL的string数组  ***/
@property(nonatomic, strong)NSArray *imageUrlStringGroup;
/***   各图片对应显示的文字的数组  ***/
@property(nonatomic, strong)NSArray *titleGroup;
/***   本地图片的名字数组  ***/
@property(nonatomic, strong)NSArray *localImageNameGroup;


//--------------------------------      滚动控制相关API      ------------------------------------//
/***   自动滚动时间间隔， 默认为3秒  ***/
@property(nonatomic, assign) CGFloat autoScrollTime;
/***   是否无限循环，默认为YES  ***/
@property(nonatomic, assign)Boolean infiniteLoop;
/***   图片滚动方向，默认水平滚动  ***/
@property(nonatomic,assign)UICollectionViewScrollDirection scrollDirection;
/***   视图代理  ***/
@property(nonatomic, weak)id<CQCycleScrollViewDelegate> delegate;
/***   block方式监听点击  ***/
@property(nonatomic, copy)void(^clickItemOperationBlock)(NSInteger currentIndex);
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/*** 手动控制滚动到指定index ***/
- (void)makeScrollViewScrollToIndex:(NSInteger)index;
/*** 若出现viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 ***/
- (void)adjustWhenControllerViewWillAppear;


//--------------------------------      显示样式相关API      ------------------------------------//
/***   轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill   ***/
@property(nonatomic, assign)UIViewContentMode bannerImageViewContentMode;
/***   是否显示分页控件   ***/
@property(nonatomic, assign)BOOL showPageControl;

/***   只展示文字轮播，默认为NO   ***/
@property(nonatomic, assign)BOOL onlyDisplayText;
/***   分页控件位置   ***/
@property(nonatomic, assign)CQCycleScrollViewPageContolAlignment pageControlAliment;


//--------------------------------      控件处理相关方法      ------------------------------------//
/***   初始化轮播图控件  ***/
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<CQCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;



@end

















