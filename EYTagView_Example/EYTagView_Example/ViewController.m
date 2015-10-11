//
//  ViewController.m
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//

#import "ViewController.h"
/**
 @[
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
 ]
 */

@interface ViewController ()<EYTagViewDelegate>
@property (strong, nonatomic) IBOutlet EYTagView *tagView;
@property (strong, nonatomic) IBOutlet EYTagView *tagView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        EYTagView* tagView=_tagView;
        tagView.colorTag=COLORRGB(0xffffff);
        tagView.colorTagBg=COLORRGB(0x2ab44e);
        tagView.colorInput=COLORRGB(0x2ab44e);
        tagView.colorInputBg=COLORRGB(0xffffff);
        tagView.colorInputPlaceholder=COLORRGB(0x2ab44e);
        tagView.backgroundColor=COLORRGB(0x00ffff);
        tagView.colorInputBoard=COLORRGB(0x2ab44e);
        tagView.viewMaxHeight=230;
        tagView.type=_type;
        
        [tagView addTags:@[
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
    
    {
        EYTagView* tagView=_tagView2;
        
        tagView.colorTag=COLORRGB(0xffffff);
        tagView.colorTagBg=COLORRGB(0x2ab44e);
        tagView.colorInput=COLORRGB(0x2ab44e);
        tagView.colorInputBg=COLORRGB(0xffffff);
        tagView.colorInputPlaceholder=COLORRGB(0x2ab44e);
        tagView.backgroundColor=COLORRGB(0x00ffff);
        tagView.colorInputBoard=COLORRGB(0x2ab44e);
        
        tagView.type=_type;
        tagView.viewMaxHeight=230;
        
        [tagView addTags:@[
                           @"pig",
                           @"duck",
                           @"horse",
                           @"elephant",
                           @"ant",
                           @"fish",                        
                           ]];
    }
    
    
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
- (IBAction)test:(id)sender {
    NSLog(@"%@",_tagView);
}
@end
