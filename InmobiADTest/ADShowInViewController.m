////
////  ADShowInViewController.m
////  Shuzan
////
////  Created by Xu小波 on 2018/7/15.
////  Copyright © 2018年 Shujin. All rights reserved.
//
/*
 1.inmobi广告变现需要在财务信息完善之后，他们的工单反馈很快，10分钟左右，点赞！
 2.每天接收的广告数在15个左右，由于app目前未推广看不出收入；
 3.强制点击的效果只是做个样子，最好不要使用(也涉及到转化率的问题，应该会被check)，不要像某些网站那样流氓。
 4.提供的测试id为链车app，请更换id
 5.正确的产品导向应该是load之后用[_inMobiAdVideo isReady]为判断显示观看按钮,建议
 */

#import "ADShowInViewController.h"

#import <objc/runtime.h>

#import <InMobiSDK/InMobiSDK.h>

@interface ADShowInViewController ()<IMInterstitialDelegate>

@property (nonatomic, strong) IMInterstitial *inMobiAdVideo;

@end

@implementation ADShowInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.inMobiAdVideo load];
}

- (IMInterstitial *)inMobiAdVideo {
    
    if (!_inMobiAdVideo) {
        
        _inMobiAdVideo = [[IMInterstitial alloc] initWithPlacementId:1532669668449];
        _inMobiAdVideo.delegate = self;
    }
    
    return _inMobiAdVideo;
}

#pragma mark - delegate

/*Indicates that the interstitial is ready to be shown */
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
    
    NSLog(@"interstitialDidFinishLoading");
    //    kIMInterstitialAnimationTypeCoverVertical
    //    kIMInterstitialAnimationTypeFlipHorizontal
    //    kIMInterstitialAnimationTypeNone
    [self.inMobiAdVideo showFromViewController:self withAnimation:kIMInterstitialAnimationTypeNone];
}
/* Indicates that the interstitial has failed to receive an ad. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial failed to load ad");
    NSLog(@"Error : %@",error.description);
}
/* Indicates that the interstitial has failed to present itself. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToPresentWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial didFailToPresentWithError");
    NSLog(@"Error : %@",error.description);
}
/* indicates that the interstitial is going to present itself. */
- (void)interstitialWillPresent:(IMInterstitial *)interstitial {
    NSLog(@"interstitialWillPresent");
}
/* Indicates that the interstitial has presented itself */
- (void)interstitialDidPresent:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidPresent");
}
/* Indicates that the interstitial is going to dismiss itself. */
- (void)interstitialWillDismiss:(IMInterstitial *)interstitial {
    NSLog(@"interstitialWillDismiss");
}
/* Indicates that the interstitial has dismissed itself. */
- (void)interstitialDidDismiss:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidDismiss");
//    ShowMessage(@"恭喜您完成任务");
}
/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromInterstitial:(IMInterstitial *)interstitial {
    NSLog(@"userWillLeaveApplicationFromInterstitial");
    
}
/* Indicates that a reward action is completed */
- (void)interstitial:(IMInterstitial *)interstitial rewardActionCompletedWithRewards:(NSDictionary *)rewards {
    NSLog(@"rewardActionCompletedWithRewards");
//    NSArray *arr = [self getAllMethodList:@"IMUIImageView"];

    UIViewController *adVc = [self topViewController];

//    UIGestureRecognizer
    for (UIView *sub in adVc.view.subviews) {

        if ([sub isKindOfClass:NSClassFromString(@"IMUIView")]) {

            for (UIView *sub2 in sub.subviews) {

                if ([sub2 isKindOfClass:NSClassFromString(@"IMUIImageView")]) {

                    UITapGestureRecognizer *gr = sub2.gestureRecognizers.lastObject;

                    if ([sub2 respondsToSelector:NSSelectorFromString(@"tapGesture:")]) {

                        [sub2 performSelector:NSSelectorFromString(@"tapGesture:") withObject:gr];
                    }
                    return;
                }
            }
        }
    }
}

//获取最上层控制器
- (UIViewController *)topViewController;{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//获取所有的成员变量名称
- (NSArray *)getAllIvarList:(NSString *)className {
    unsigned int methodCount = 0;
    Ivar * ivars = class_copyIvarList([NSClassFromString(className) class], &methodCount);
    NSMutableArray *names = [NSMutableArray array];
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        //        const char * type = ivar_getTypeEncoding(ivar);
        //        NSLog(@"Person拥有的成员变量的类型为%s，名字为 %s ",type, name);
        [names addObject:[[NSString stringWithFormat:@"%s",name] stringByReplacingOccurrencesOfString:@"_" withString:@""]];
    }
    free(ivars);
    
    return names;
}

//获取所有的成员函数
- (NSArray *)getAllMethodList:(NSString *)className {
    unsigned int methodCount = 0;
    Method * ivars = class_copyMethodList([NSClassFromString(className) class], &methodCount);
    NSMutableArray *names = [NSMutableArray array];
    for (unsigned int i = 0; i < methodCount; i ++) {
        Method ivar = ivars[i];
        NSString * name = NSStringFromSelector(method_getName(ivar));
        //        const char * type = ivar_getTypeEncoding(ivar);
        //        NSLog(@"Person拥有的成员变量的类型为%s，名字为 %s ",type, name);
        [names addObject:[[NSString stringWithFormat:@"%@",name] stringByReplacingOccurrencesOfString:@"_" withString:@""]];
    }
    free(ivars);
    
    return names;
}

/* interstitial:didInteractWithParams: Indicates that the interstitial was interacted with. */
- (void)interstitial:(IMInterstitial *)interstitial didInteractWithParams:(NSDictionary *)params {
    NSLog(@"InterstitialDidInteractWithParams");
}
/// * Not used for direct integration. Notifies the delegate that the ad server has returned an ad but assets are not yet available. */
- (void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidReceiveAd");
}

@end
