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
                        @"dog",
                        @"cat",
                        @"pig",
                        @"duck",
                        @"horse",
                        @"elephant",
                        @"ant",
                        @"fish",
                        @"bird",
                        @"engle",
                        @"snake",
                        @"mouse",
                        @"squirrel",
                        @"beaver",
                        @"kangaroo",
                        @"monkey",
                        @"panda",
                        @"bear",
                        @"lion",
                        ]];
}

- (IBAction)layout:(id)sender {
    [_tagView layoutTagviews];
}

-(void)heightDidChangedTagView:(EYTagView *)tagView{
    NSLog(@"heightDidChangedTagView");
}
- (IBAction)toggleType:(UISwitch*)sender {
    _tagView.type=sender.on?EYTagView_Type_Edit:EYTagView_Type_Display;
}
- (IBAction)handlerSegmentAction:(UISegmentedControl*)sender {
    _tagView.type=(EYTagView_Type)sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
}
@end
