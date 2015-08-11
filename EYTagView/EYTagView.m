//
//  EYTagView.m
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//





#import "EYTagView.h"

@interface EYCheckBoxButton :UIButton
@property (nonatomic, strong) UIColor* colorBg;
@property (nonatomic, strong) UIColor* colorText;
@end

@implementation EYCheckBoxButton
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:_colorBg];
        [self setTitleColor:_colorText forState:UIControlStateSelected];
    } else {
        [self setBackgroundColor:_colorText];
        self.layer.borderColor=_colorBg.CGColor;
        self.layer.borderWidth=1;
        [self setTitleColor:_colorBg forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}
@end


@interface EYTextField : UITextField

@end
@implementation EYTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 6 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 6 , 0 );
}

@end


@interface EYTagView()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView* svContainer;

@property (nonatomic, strong) NSMutableArray *tagButtons;//array of alll tag button
@property (nonatomic, strong) NSMutableArray *tagStrings;//check whether tag is duplicated
@property (nonatomic, strong) NSMutableArray *tagStringsSelected;




@property (nonatomic) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation EYTagView
{
    NSInteger _editingTagIndex;
}


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


- (void)commonInit
{
    _type=EYTagView_Type_Edit;
    _tagWidht=55;
    _tagHeight=15;
    _tagPaddingSize=CGSizeMake(3, 3);
    _textPaddingSize=CGSizeMake(0, 3);
    _fontTag=[UIFont systemFontOfSize:12];
    _fontInput=[UIFont systemFontOfSize:12];
    _colorTag=COLORRGB(0xffffff);
    _colorInput=COLORRGB(0x2ab44e);
    _colorInputPlaceholder=COLORRGB(0x2ab44e);
    _colorTagBg=COLORRGB(0x2ab44e);
    _colorInputBg=COLORRGB(0xbbbbbb);
    _colorInputBoard=COLORRGB(0x2ab44e);
    _viewMaxHeight=130;
    self.backgroundColor=COLORRGB(0xffffff);
    
    _tagButtons=[NSMutableArray new];
    _tagStrings=[NSMutableArray new];
    _tagStringsSelected=[NSMutableArray new];
    
    {
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        sv.contentSize=sv.frame.size;
        sv.contentSize=CGSizeMake(sv.frame.size.width, 600);
        sv.indicatorStyle=UIScrollViewIndicatorStyleDefault;
        sv.backgroundColor = self.backgroundColor;
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        [self addSubview:sv];
        _svContainer=sv;
    }
    {
        UITextField* tf = [[EYTextField alloc] initWithFrame:CGRectMake(0, 0, _tagWidht, _tagHeight)];
        tf.autocorrectionType = UITextAutocorrectionTypeNo;
        [tf addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        tf.delegate = self;
        tf.placeholder=@"add tag";
      
        tf.returnKeyType = UIReturnKeyDone;
        [_svContainer addSubview:tf];
        _tfInput=tf;
    }
    {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _gestureRecognizer.numberOfTapsRequired=1;
        [self addGestureRecognizer:_gestureRecognizer];
    }
}
#pragma mark -
-(NSMutableArray *)tagStrings{
      switch (_type) {
        case EYTagView_Type_Edit:
        {
            return _tagStrings;
        }
            break;
        case EYTagView_Type_Display:
        {
            return nil;
        }
            break;
        case EYTagView_Type_Single_Selected:
        {
            [_tagStringsSelected removeAllObjects];
            for (EYCheckBoxButton* button in _tagButtons) {
                if (button.selected) {
                    [_tagStringsSelected addObject:button.titleLabel.text];
                    break;
                }
            }
            return _tagStringsSelected;
        }
            break;
        case EYTagView_Type_Multi_Selected:
        {
            [_tagStringsSelected removeAllObjects];
            for (EYCheckBoxButton* button in _tagButtons) {
                if (button.selected) {
                    [_tagStringsSelected addObject:button.titleLabel.text];
                }
            }
            return _tagStringsSelected;
        }
              break;
        default:
        {
            
        }
            break;
    }
    return nil;
}


-(void)layoutTagviews{
    float oldContentHeight=_svContainer.contentSize.height;
    float offsetX=_tagPaddingSize.width,offsetY=_tagPaddingSize.height;
    
    for (int i=0; i<_tagButtons.count; i++) {
        EYCheckBoxButton* tagButton=_tagButtons[i];
        CGRect frame=tagButton.frame;
        
        if (tagButton.frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
            NSLog(@"!!!  tagButton width tooooooooo large");
        }else{
            if ((offsetX+tagButton.frame.size.width+_tagPaddingSize.width)
                <=_svContainer.contentSize.width) {
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=tagButton.frame.size.width+_tagPaddingSize.width;
            }else{
                offsetX=_tagPaddingSize.width;
                offsetY+=_tagHeight+_tagPaddingSize.height;
                
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=tagButton.frame.size.width+_tagPaddingSize.width;
            }
            tagButton.frame=frame;
        }
    }
    //input view
    _tfInput.hidden=(_type!=EYTagView_Type_Edit);
    if (_type==EYTagView_Type_Edit) {
        _tfInput.backgroundColor=_colorInputBg;
        _tfInput.textColor=_colorInput;
        _tfInput.font=_fontInput;
        [_tfInput setValue:_colorInputPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
        
        _tfInput.layer.cornerRadius = _tfInput.frame.size.height * 0.5f;
        _tfInput.layer.borderColor=_colorInputBoard.CGColor;
        _tfInput.layer.borderWidth=1;
        {
            CGRect frame=_tfInput.frame;
            frame.size.width = [_tfInput.text sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2;
            frame.size.width=MAX(frame.size.width, _tagWidht);
            _tfInput.frame=frame;
        }
        
        if (_tfInput.frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
            NSLog(@"!!!  _tfInput width tooooooooo large");
            
        }else{
            CGRect frame=_tfInput.frame;
            if ((offsetX+_tfInput.frame.size.width+_tagPaddingSize.width)
                <=_svContainer.contentSize.width) {
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=_tfInput.frame.size.width+_tagPaddingSize.width;
            }else{
                offsetX=_tagPaddingSize.width;
                offsetY+=_tagHeight+_tagPaddingSize.height;
                
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=_tfInput.frame.size.width+_tagPaddingSize.width;
            }
            _tfInput.frame=frame;
            
        }
        
    }
    
    _svContainer.contentSize=CGSizeMake(_svContainer.contentSize.width, offsetY+_tagHeight+_tagPaddingSize.height);
    {
        CGRect frame=_svContainer.frame;
        frame.size.height=_svContainer.contentSize.height;
        frame.size.height=MIN(frame.size.height, _viewMaxHeight);
        _svContainer.frame=frame;
    }
    {
        CGRect frame=self.frame;
        frame.size.height=_svContainer.frame.size.height;
        self.frame=frame;
    }
    if (_delegate) {
        [_delegate heightDidChangedTagView:self];
    }
    if (oldContentHeight != _svContainer.contentSize.height) {
        CGPoint bottomOffset = CGPointMake(0, _svContainer.contentSize.height - _svContainer.bounds.size.height);
        [_svContainer setContentOffset:bottomOffset animated:YES];
    }
}

- (EYCheckBoxButton *)tagButtonWithTag:(NSString *)tag
{
    EYCheckBoxButton *tagBtn = [[EYCheckBoxButton alloc] init];
    tagBtn.colorBg=_colorTagBg;
    tagBtn.colorText=_colorTag;
    tagBtn.selected=YES;
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
- (void)handlerTagButtonEvent:(EYCheckBoxButton*)sender
{
    
}
#pragma mark action

- (void)addTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        [self addTagToLast:tag];
    }
    [self layoutTagviews];
}
- (void)addTags:(NSArray *)tags selectedTags:(NSArray*)selectedTags{
    [self addTags:tags];
    self.tagStringsSelected=[NSMutableArray arrayWithArray:selectedTags];
}
- (void)addTagToLast:(NSString *)tag{
    NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
    if (result.count == 0)
    {
        [_tagStrings addObject:tag];
        
        EYCheckBoxButton* tagButton=[self tagButtonWithTag:tag];
        [tagButton addTarget:self action:@selector(handlerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_svContainer addSubview:tagButton];
        [_tagButtons addObject:tagButton];
        
        switch (_type) {
            case EYTagView_Type_Single_Selected:
            case EYTagView_Type_Multi_Selected:
            {
                tagButton.selected=NO;
            }
                break;
            default:
                break;
        }
    }
    [self layoutTagviews];
}

- (void)removeTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        [self removeTag:tag];
    }
    [self layoutTagviews];
}
- (void)removeTag:(NSString *)tag{
    NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
    if (result)
    {
        NSInteger index=[_tagStrings indexOfObject:tag];
        [_tagStrings removeObjectAtIndex:index];
        [_tagButtons[index] removeFromSuperview];
        [_tagButtons removeObjectAtIndex:index];
    }
    [self layoutTagviews];
}


-(void)handlerButtonAction:(EYCheckBoxButton*)tagButton{
    switch (_type) {
        case EYTagView_Type_Edit:
        {
            [self becomeFirstResponder];
            _editingTagIndex=[_tagButtons indexOfObject:tagButton];
            CGRect buttonFrame=tagButton.frame;
            buttonFrame.size.height-=5;
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteItemClicked:)];
            
            NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
            [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
            [menuController setTargetRect:buttonFrame inView:_svContainer];
            [menuController setMenuVisible:YES animated:YES];
        }
            break;
        case EYTagView_Type_Single_Selected:
        {
            if (tagButton.selected) {
                tagButton.selected=NO;
            }else{
                for (EYCheckBoxButton* button in _tagButtons) {
                    button.selected=NO;
                }
                tagButton.selected=YES;
            }
        }
            break;
        case EYTagView_Type_Multi_Selected:
        {
            tagButton.selected=!tagButton.selected;
        }
            break;
        default:
        {
            
        }
            break;
    }
    
}


#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (!textField.text
        || [textField.text isEqualToString:@""]) {
        return NO;
    }
    [self addTagToLast:textField.text];
    textField.text=nil;
    [self layoutTagviews];
    return NO;
}

-(void)textFieldDidChange:(UITextField*)textField{
    [self layoutTagviews];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* sting2= [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    CGRect frame=_tfInput.frame;
    frame.size.width = [sting2 sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2;
    frame.size.width=MAX(frame.size.width, _tagWidht);
    
    if (frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
        NSLog(@"!!!  _tfInput width tooooooooo large");
        return NO;
    }
    else{
        return YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([_delegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate performSelector:@selector(textFieldDidBeginEditing:) withObject:textField];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self layoutTagviews];
    if ([_delegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
    }
}
#pragma mark UIMenuController

- (void) deleteItemClicked:(id) sender {
    [self removeTag:_tagStrings[_editingTagIndex]];
}
- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(deleteItemClicked:) /*|| selector == @selector(copy:)*/ /*<--enable that if you want the copy item */) {
        return YES;
    }
    return NO;
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
#pragma mark getter & setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _svContainer.backgroundColor=backgroundColor;
}
-(void)setType:(EYTagView_Type)type{
    _type=type;
    switch (_type) {
        case EYTagView_Type_Edit:
        {
            for (UIButton* button in _tagButtons) {
                button.selected=YES;
            }
        }
            break;
        case EYTagView_Type_Display:
        {
            for (UIButton* button in _tagButtons) {
                button.selected=YES;
            }
        }
            break;
        case EYTagView_Type_Single_Selected:
        {
            for (UIButton* button in _tagButtons) {
                button.selected=[_tagStringsSelected containsObject:button.titleLabel.text];
            }
        }
            break;
        case EYTagView_Type_Multi_Selected:
        {
            for (UIButton* button in _tagButtons) {
                button.selected=[_tagStringsSelected containsObject:button.titleLabel.text];
            }
        }
            break;
        default:
        {
            
        }
            break;
    }
    [self layoutTagviews];
}
-(void)setColorTagBg:(UIColor *)colorTagBg{
    _colorTagBg=colorTagBg;
    for (EYCheckBoxButton* button in _tagButtons) {
        button.colorBg=colorTagBg;
    }
}
-(void)setColorTag:(UIColor *)colorTag{
    _colorTag=colorTag;
    for (EYCheckBoxButton* button in _tagButtons) {
        button.colorText=colorTag;
    }
}
-(void)setTagStringsSelected:(NSMutableArray *)tagStringsSelected{
    _tagStringsSelected=tagStringsSelected;
    switch (_type) {
        case EYTagView_Type_Single_Selected:
        case EYTagView_Type_Multi_Selected:
        {
            for (UIButton* button in _tagButtons) {
                button.selected=[tagStringsSelected containsObject:button.titleLabel.text];
            }
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
