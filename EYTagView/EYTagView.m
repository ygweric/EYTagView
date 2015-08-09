//
//  EYTagView.m
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//

#import "EYTagView.h"


@interface EYTagView()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView* svContainer;
@property (nonatomic, strong) UITextField* tfInput;
@property (nonatomic, strong) NSMutableArray *tagViews;//array of alll tag button
@property (nonatomic, strong) NSMutableArray *tagStrings;//check whether tag is duplicated

@property (nonatomic) float tagWidht;//default
@property (nonatomic) float tagHeight;//default

@property (nonatomic) float viewMaxHeight;

//@property (nonatomic) UIEdgeInsets tagEdgeInsets;
@property (nonatomic) CGSize tagPaddingSize;//top & left
//@property (nonatomic) UIEdgeInsets textEdgeInsets;
@property (nonatomic) CGSize textPaddingSize;


@property (nonatomic, strong) UIFont* fontTag;
@property (nonatomic, strong) UIFont* fontInput;


@property (nonatomic, strong) UIColor* colorTag;
@property (nonatomic, strong) UIColor* colorInput;

@property (nonatomic, strong) UIColor* colorTagBg;
@property (nonatomic, strong) UIColor* colorInputBg;


@end

@implementation EYTagView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib{
    [self commonInit];
}

- (void)commonInit
{
    _tagWidht=40;
    _tagHeight=15;
//    _tagEdgeInsets=UIEdgeInsetsMake(3, 3, 3, 3);
//    _textEdgeInsets=UIEdgeInsetsMake(3, 3, 3, 3);
    _tagPaddingSize=CGSizeMake(3, 3);
    _textPaddingSize=CGSizeMake(0, 3);
    _fontTag=[UIFont systemFontOfSize:12];
    _fontInput=[UIFont systemFontOfSize:12];
    _colorTag=COLORRGB(0x00ff00);
    _colorInput=COLORRGB(0x00ffc0);
    _colorTagBg=COLORRGB(0xaaaaaa);
    _colorInputBg=COLORRGB(0xbbbbbb);
    _viewMaxHeight=100;
    
    
    _tagViews=[NSMutableArray new];
    _tagStrings=[NSMutableArray new];
    
    {
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        sv.contentSize=sv.frame.size;
        sv.backgroundColor = COLORRGBA(0xff0000, 0.4);
        sv.showsVerticalScrollIndicator = NO;
        sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:sv];
        _svContainer=sv;
    }
    {
        UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _tagWidht, _tagHeight)];
        tf.autocorrectionType = UITextAutocorrectionTypeNo;
        tf.delegate = self;
        tf.returnKeyType = UIReturnKeyDone;
        [_svContainer addSubview:tf];
    }
    
}
#pragma mark -

-(void)layoutSubviews{
    [self.svContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float offsetX=_tagPaddingSize.width,offsetY=_tagPaddingSize.height;
//    float offsetX=0,offsetY=0;
    
    for (int i=0; i<_tagStrings.count; i++) {
        NSString* tagString = _tagStrings[i];
        UIButton* tagView=[self tagButtonWithTag:tagString];
        [_svContainer addSubview:tagView];
        CGRect frame=tagView.frame;
        
        if (tagView.frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
            NSLog(@"!!!  tagView width tooooooooo large");
            continue;
        }
        
        if ((offsetX+tagView.frame.size.width+_tagPaddingSize.width)
                <=_svContainer.contentSize.width) {
            frame.origin.x=offsetX;
            frame.origin.y=offsetY;
            offsetX+=tagView.frame.size.width+_tagPaddingSize.width;
        }else{
            offsetX=_tagPaddingSize.width;
            offsetY+=_tagHeight+_tagPaddingSize.height;
            
            frame.origin.x=offsetX;
            frame.origin.y=offsetY;
            offsetX+=tagView.frame.size.width+_tagPaddingSize.width;
        }
        tagView.frame=frame;

    }
    _svContainer.contentSize=CGSizeMake(_svContainer.contentSize.width, offsetY+_tagHeight+_tagPaddingSize.height);
    {
        CGRect frame=_svContainer.frame;
        frame.size.height=_svContainer.contentSize.height;
        frame.size.height=MIN(frame.size.height, _viewMaxHeight);
    }
}

- (UIButton *)tagButtonWithTag:(NSString *)tag
{
    UIButton *tagBtn = [[UIButton alloc] init];
    [tagBtn.titleLabel setFont:_fontTag];
    [tagBtn setBackgroundColor:_colorTagBg];
    [tagBtn setTitleColor:_colorTag forState:UIControlStateNormal];
    [tagBtn addTarget:self action:@selector(handlerTagButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    
    CGRect btnFrame;
    btnFrame.size.height = _tagHeight;
    tagBtn.layer.cornerRadius = btnFrame.size.height * 0.5f;
    
    btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_fontTag}].width + (tagBtn.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2;
    
    tagBtn.frame=btnFrame;
    return tagBtn;
}
- (void)handlerTagButtonEvent:(UIButton*)sender
{
}
#pragma mark action

- (void)addTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result.count == 0)
        {
            [_tagStrings addObject:tag];
        }
    }
    [self setNeedsLayout];
}

- (void)addTagToLast:(NSString *)tag{
    
}

- (void)removeTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result)
        {
            [_tagStrings removeObjectsInArray:result];
        }
    }
    [self setNeedsLayout];
}





#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}







































@end
