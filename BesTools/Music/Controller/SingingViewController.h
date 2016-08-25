//
//  SingingViewController.h
//  MusicPlayer
//
//  Created by dllo on 16/1/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
#import <AVFoundation/AVFoundation.h>

@interface SingingViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *listArray;;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, assign) BOOL playOrPause;
@property (nonatomic, assign) BOOL lycYesOrNo;
@property (nonatomic, retain) UITableView *lrcTableView;//小歌词界面
@property (nonatomic, retain) UITableView *bigLrcTableView;//大歌词界面
@property (nonatomic, retain) UIImageView *imageViewSceond;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *picImageView;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) NSMutableArray *lrcTime;
@property (nonatomic, copy) NSString *currTime;
@property (nonatomic, retain) NSMutableArray *lrcAll;
@property (nonatomic, retain) UIAlertController *alert;


- (void)musicplay:(NSString *)str;
- (void)createLrc:(NSString *)str;
- (void)createPicture:(NSString *)str;
@end
