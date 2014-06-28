//
//  SVSViewController.m
//  scrollViewSample
//
//  Created by 武田 祐一 on 2013/04/19.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#import "SVSViewController.h"

@interface SVSViewController ()
    @property (strong, nonatomic) UIScrollView *scrollView;
@end


@implementation SVSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = (UIScrollView *)[[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
    UIImage *image = [UIImage imageNamed:@"big_image.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    
    [self.scrollView addSubview:imageView];
    
    self.scrollView.contentSize = imageView.frame.size;
    self.scrollView.maximumZoomScale = 3.0; // 最大倍率
    self.scrollView.minimumZoomScale = 0.5; // 最小倍率
    
    self.scrollView.delegate = self;
    
    //[self.scrollView setContentOffset:CGPointMake(200,200) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(200,200) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scroll中です");
}

@end
