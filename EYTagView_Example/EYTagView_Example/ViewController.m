//
//  ViewController.m
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//

#import "ViewController.h"
#import "EYTagView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet EYTagView *tagView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
                        ]];
}

- (IBAction)layout:(id)sender {
    [_tagView setNeedsLayout];
}


@end
