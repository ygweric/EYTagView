//
//  ViewController.m
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//

#import "ViewController.h"
#import "EYTagView.h"

@interface ViewController ()<EYTagViewDelegate>
@property (strong, nonatomic) IBOutlet EYTagView *tagView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tagView.translatesAutoresizingMaskIntoConstraints=YES;
    _tagView.delegate=self;
    
    _tagView.colorTag=COLORRGB(0xffffff);
    _tagView.colorTagBg=COLORRGB(0x2ab44e);
    _tagView.colorInput=COLORRGB(0x2ab44e);
    _tagView.colorInputBg=COLORRGB(0xffffff);
    _tagView.colorInputPlaceholder=COLORRGB(0x2ab44e);
    _tagView.backgroundColor=COLORRGB(0xffffff);
    _tagView.colorInputBoard=COLORRGB(0x2ab44e);
    _tagView.viewMaxHeight=130;
    
    [_tagView addTags:@[
                        @"111",
                        @"222",
                        @"犬瘟热",
                        @"惹我欠人情无人区污染污染",
                        @"3而是",
                        @"是",
                        @"是放大法撒旦",
                        @"撒的发",
                        @"阿斯顿发发生法士大夫",
                        @"撒的发",
                        @"阿是发放的",
                        @"asdfasdf啊大法师",
                        @"阿发",
                        @"撒的发是否是地方萨菲阿Sa",
                        @"发色发",
                        @"额发我份",
                        @"会计法",
                        @"客人房交付给",
                        @"ut6utfj大一点",
                        @"考估计附加费",
                        @"开房间风好大",
                        @"人提交方法",
                        @"i7uhft 代发货",
                        @"放开眼界",
                        @"7就仿佛",
                        @"他附加费",
                        @"丰台ifi7",
                        @"iyiiuiui国防教育",
                        ]];
}

- (IBAction)layout:(id)sender {
    [_tagView layoutTagviews];
}

-(void)heightDidChangedTagView:(EYTagView *)tagView{
    NSLog(@"heightDidChangedTagView");
}
- (IBAction)toggleType:(UISwitch*)sender {
    _tagView.type=sender.on?EYTagView_Type_Edit:EYTagView_Type_NO_Edit;
}
@end
