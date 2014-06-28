//
//  FocusViewController.m
//  ThumbnailFocus
//
//  Created by 鄭 基旭 on 2013/04/18.
//  Copyright (c) 2013年 鄭 基旭. All rights reserved.
//

#import "FocusViewController.h"

static NSTimeInterval const kDefaultOrientationAnimationDuration = 0.4;

@interface FocusViewController ()
@property (nonatomic, assign) UIDeviceOrientation previousOrientation;
@end

#warning 「⬇ Answer：」マークがあるラインにコメントで簡単な解説文を書いてください。

@implementation FocusViewController

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mainImageView = nil;
    self.contentView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // ⬇Answer：画面の向きが変わった時に、orientationDidChangeNotificationを呼ぶ
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    // ⬇Answer：画面の向きが変わった時に、orientation（画面の向き）の値を通知する。下記メソッドを呼ばないと、画面の向きが取得できない。
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // ⬇Answer：viewDidAppearで設定した、orientationDidChangeNotificationを呼び出す設定を削除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    // ⬇Answer：viewDidAppearで設定した、orientation（画面の向き）の値を通知する設定を削除
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (NSUInteger)supportedInterfaceOrientations
{
    // ⬇Answer：ホームボタンが下のときのみ許可する（ただし、親VIEWがホームボタン上時を許可しているため、親VIEWが回転してしまう。。）
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)isParentSupportingInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch(toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;

        case UIInterfaceOrientationPortraitUpsideDown:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortraitUpsideDown;

        case UIInterfaceOrientationLandscapeLeft:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeLeft;

        case UIInterfaceOrientationLandscapeRight:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeRight;
    }
}


/////////////////////////////////////////////////////////////
// ⬇Answer： 次の関数は回転時のアニメーションを担当しています。
//　82ラインから140ラインまで、すべてのラインにコメントを書いてください。
/////////////////////////////////////////////////////////////
- (void)updateOrientationAnimated:(BOOL)animated
{
    //アフィン変換クラス（回転、拡大、縮小、平行移動）
    CGAffineTransform transform;
    //時間を表すクラス このコードだとアニメーションする時間で利用している　0.4秒
    NSTimeInterval duration = kDefaultOrientationAnimationDuration;

    //同じ向きだった場合、何もしない
    if([UIDevice currentDevice].orientation == self.previousOrientation)
        return;

    //横向き＝＞横向き、縦向き＝＞縦向きの場合、アニメーションする時間を2倍にする
    if((UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsLandscape(self.previousOrientation))
       || (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsPortrait(self.previousOrientation)))
    {
        duration *= 2;
    }

    //画面が縦、もしくはサポートしている向きだったら変形した画像を変形していない状態のものに戻す
    if(([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait)
       || [self isParentSupportingInterfaceOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation]) {
        //元に戻す
        transform = CGAffineTransformIdentity;
    }else {
        //デバイスの向きによって動作を変化
        switch ([UIDevice currentDevice].orientation){
            // 横（ホームボタンが左）のとき
            case UIInterfaceOrientationLandscapeLeft:
                // 縦（ホームボタン下）から遷移したとき
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait) {
                    // 画像を90°右に回転
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }else {
                    // 画像を90°左に回転
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }
                break;
            // 横（ホームボタンが右）のとき
            case UIInterfaceOrientationLandscapeRight:
                //縦（ホームボタン下）から遷移したとき
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait) {
                    // 画像を90°左に回転
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }else {
                    // 画像を90°右に回転
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                break;
            // 縦（ホームボタンが下）のとき
            case UIInterfaceOrientationPortrait:
                // 元の画像に戻す
                transform = CGAffineTransformIdentity;
                break;
            // 縦（ホームボタンが上）のとき
            case UIInterfaceOrientationPortraitUpsideDown:
                // 画像を180°回転
                transform = CGAffineTransformMakeRotation(M_PI);
                break;

            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationUnknown:
                return;
        }
    }

    // CGRect（画面サイズ用クラス）の初期値に0,0を設定
    CGRect frame = CGRectZero;
    
    // アニメーションありのとき
    if(animated) {
        // 現在の画面サイズを取得
        frame = self.contentView.frame;
        // 設定したアフィン変換クラスでアニメーションを行う
        [UIView animateWithDuration:duration
                         animations:^{
                             self.contentView.transform = transform;
                             self.contentView.frame = frame;
                         }];
    // アニメーションなし
    }else {
        frame = self.contentView.frame;
        self.contentView.transform = transform;
        self.contentView.frame = frame;
    }
    // 次に向きが変わった時に利用するので、アニメーション後の画面向きを保存しておく
    self.previousOrientation = [UIDevice currentDevice].orientation;
}

#pragma mark - Notifications
// ⬇Answer：こちはいつ呼ばれますか？
//画面の向きがかわったとき。
- (void)orientationDidChangeNotification:(NSNotification *)notification
{
    [self updateOrientationAnimated:YES];
}
@end