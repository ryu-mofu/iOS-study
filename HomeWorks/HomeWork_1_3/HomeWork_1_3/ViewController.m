//
//  ViewController.m
//  HomeWork_1_3
//
//  Created by ryu on 2014/06/04.
//  Copyright (c) 2014年 Nippon Television Network Corporation. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //画像をランダムでセット
    [self.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",arc4random_uniform(4)]]];
    //画像の縦横比を維持する
    self.imageView.contentMode = UIViewContentModeTop;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(clickCloseBtn:)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Aboutボタンをタッチした時の処理(モーダル)
- (IBAction)clickAboutBtn:(id)sender {
    ViewController *mainViewController = [self getMainViewController];
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

//Profileボタンをタッチした時の処理(プッシュ)
- (IBAction)clickProfileBtn:(id)sender {
    ViewController *mainViewController = [self getMainViewController];
    
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (ViewController *)getMainViewController {
    //StoryBoardからViewを取得
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainImageView"];
    return mainViewController;
}

- (void)clickCloseBtn:(id)sender
{
[self dismissViewControllerAnimated:YES completion:nil];
}

@end
