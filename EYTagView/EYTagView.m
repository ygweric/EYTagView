//
//  EYTagView.m
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//





#import "EYTagView.h"
#import "EYTextField.h"

#ifndef EYLOCALSTRING
#define EYLOCALSTRING(STR) NSLocalizedString(STR, STR)
#endif

@interface EYCheckBoxButton :UIButton
@property (nonatomic, strong) UIColor* colorBg;
@property (nonatomic, strong) UIColor* colorText;
@property (nonatomic, strong) UIColor* colorTagUnSelected;
@property (nonatomic, strong) UIColor* colorTagBorder;

@end

@implementation EYCheckBoxButton
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:_colorBg];
        self.layer.borderColor=_colorBg.CGColor;
        [self setTitleColor:_colorText forState:UIControlStateSelected];
    } else {
        [self setBackgroundColor:COLORRGB(0xffffff)];
        self.layer.borderColor=_colorTagBorder.CGColor;
        self.layer.borderWidth=1;
        [self setTitleColor:_colorTagUnSelected forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}
@end


@interface EYTagView()<UITextFieldDelegate>
@property (nonatomic) CGFloat newHeight;
@property (nonatomic, strong) UIScrollView* svContainer;
@property (nonatomic, strong) NSMutableArray *tagStrings;//check whether tag is duplicated
@property (nonatomic, strong) NSMutableArray *tagButtons;//array of alll tag button
@property (nonatomic, strong) NSMutableArray *tagStringsSelected;
@property (assign) NSInteger tagButtonSelecteds;

@end

@implementation EYTagView
{
    NSInteger _editingTagIndex;
    BOOL _isInit;
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
    _newHeight=self.frame.size.height;
    _type=EYTagView_Type_Edit;
    _tagHeight=18;
    _tagPaddingSize=CGSizeMake(6, 6);
    _textPaddingSize=CGSizeMake(0, 3);
    _fontTag=[UIFont systemFontOfSize:14];
    self.fontInput=[UIFont systemFontOfSize:14];
    _colorTag=COLORRGB(0xffffff);
    _colorTagUnselected=COLORRGB(0xa1a2a2);
    _colorInput=COLORRGB(0x2ab44e);
    _colorInputPlaceholder=COLORRGB(0x2ab44e);
    _colorTagBg=COLORRGB(0x2ab44e);
    _colorTagBoard=COLORRGB(0xdddddd);
    _colorInputBg=COLORRGB(0xbbbbbb);
    _colorInputBoard=COLORRGB(0x2ab44e);
    _viewMaxHeight=130;
    self.clipsToBounds=YES;
    self.backgroundColor=COLORRGB(0xffffff);
    _maxSelected = 0;
    _tagButtonSelecteds = 0;
    
    _tagButtons=[NSMutableArray new];
    _tagArrows=[NSMutableArray new];
    _tagStrings=[NSMutableArray new];
    _tagStringsSelected=[NSMutableArray new];
    
    {
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        sv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
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
        UITextField* tf = [[EYTextField alloc] initWithFrame:CGRectMake(0, 0, 0, _tagHeight)];
        tf.autocorrectionType = UITextAutocorrectionTypeNo;
        [tf addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        tf.delegate = self;
        tf.placeholder=EYLOCALSTRING(@"Add Tag");
        tf.returnKeyType = UIReturnKeyDone;
        [_svContainer addSubview:tf];
        _tfInput=tf;
    }
    {
        UITapGestureRecognizer* panGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector
        (handlerTapGesture:)];
        panGestureRecognizer.numberOfTapsRequired=1;
        [self addGestureRecognizer:panGestureRecognizer];
    }
}
#pragma mark -
-(NSMutableArray *)tagStrings{
      switch (_type) {
        case EYTagView_Type_Edit:
        case EYTagView_Type_Edit_Only_Delete:
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
        case EYTagView_Type_Multi_Selected_Edit:
        {
            [_tagStringsSelected removeAllObjects];
            for (EYCheckBoxButton* button in _tagButtons) {
                if (button.selected) {
                    [_tagStringsSelected addObject:button.titleLabel.text];
                }
            }
            return _tagStringsSelected;
        }
        default:
        {
            
        }
            break;
    }
    return nil;
}
-(UIView*)newArrowView{
    UIView* vArrow=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tagHeight*1.5f, _tagHeight)];
    vArrow.backgroundColor=[UIColor clearColor];
    {
        UILabel* lb=[[UILabel alloc]initWithFrame:vArrow.frame];
        lb.textAlignment=NSTextAlignmentCenter;
        lb.text=@"···>";
        lb.font=[UIFont systemFontOfSize:13];
        lb.textColor=_colorTagBg;
        lb.backgroundColor=[UIColor clearColor];
        [vArrow addSubview:lb];
    }
    
    
    return vArrow;
}

-(void)layoutTagviews{
    float oldContentHeight=_svContainer.contentSize.height;
    float offsetX=_tagPaddingSize.width,offsetY=_tagPaddingSize.height;
    
    if (_type==EYTagView_Type_Flow){
        for (UIView* v in _tagArrows) {
            [v removeFromSuperview];
        }
        [_tagArrows removeAllObjects];

    }
    
    BOOL needLayoutAgain=NO;// just for too large text
    BOOL shouldFinishLayout=NO;//just for break line
    int currentLine=0;
    for (int i=0; i<_tagButtons.count; i++) {
        EYCheckBoxButton* tagButton=_tagButtons[i];
        tagButton.hidden=NO;
        if (shouldFinishLayout) {
            tagButton.hidden=YES;
            continue;
        }
        CGRect frame=tagButton.frame;
        
        if (tagButton.frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
            NSLog(@"!!!  tagButton width tooooooooo large");
            [tagButton removeFromSuperview];
            [_tagButtons removeObjectAtIndex:i];
            [_tagStrings removeObjectAtIndex:i];
            needLayoutAgain=YES;
            break;
        }else{
            //button
            if ((offsetX+tagButton.frame.size.width+_tagPaddingSize.width)
                <=_svContainer.contentSize.width) {
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=tagButton.frame.size.width+_tagPaddingSize.width;
            }else{//break line
                currentLine++;
                if (_numberOfLines!=0
                    && _numberOfLines<=currentLine) {
                    shouldFinishLayout=YES;
                    if (_type==EYTagView_Type_Flow
                        && i!=0) {//not first one
                        [_tagArrows.lastObject removeFromSuperview];
                        [_tagArrows removeLastObject];
                    }
                    tagButton.hidden=YES;
                    continue;
                }
                
                offsetX=_tagPaddingSize.width;
                offsetY+=_tagHeight+_tagPaddingSize.height;
                
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=tagButton.frame.size.width+_tagPaddingSize.width;
            }
            tagButton.frame=frame;
            //arrow
            if (_type==EYTagView_Type_Flow
                && i!=_tagButtons.count-1) {
                UIView* vArrow=[self newArrowView];
                
                frame=vArrow.frame;
                if ((offsetX+vArrow.frame.size.width+_tagPaddingSize.width)
                    <=_svContainer.contentSize.width) {
                    frame.origin.x=offsetX;
                    frame.origin.y=offsetY;
                    offsetX+=vArrow.frame.size.width+_tagPaddingSize.width;
                }else{//break line
                    currentLine++;
                    if (_numberOfLines!=0
                        && _numberOfLines<=currentLine) {
                        shouldFinishLayout=YES;
                        continue;
                    }
                    
                    offsetX=_tagPaddingSize.width;
                    offsetY+=_tagHeight+_tagPaddingSize.height;
                    
                    frame.origin.x=offsetX;
                    frame.origin.y=offsetY;
                    offsetX+=vArrow.frame.size.width+_tagPaddingSize.width;
                }
                vArrow.frame=frame;
                [_tagArrows addObject:vArrow];
                [_svContainer addSubview:vArrow];
            }
        }
    }
    if (needLayoutAgain) {
        [self layoutTagviews];
        return;
    }
    //input view
    _tfInput.hidden=(_type!=EYTagView_Type_Edit &&
                     _type!=EYTagView_Type_Multi_Selected_Edit);
    if (_type==EYTagView_Type_Edit || _type==EYTagView_Type_Multi_Selected_Edit) {
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
            //place holde width
            frame.size.width=MAX(frame.size.width, [EYLOCALSTRING(@"Add Tag") sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2);
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
    
    _svContainer.contentSize=CGSizeMake(_svContainer.frame.size.width, offsetY+_tagHeight+_tagPaddingSize.height);
    {
        CGRect frame=_svContainer.frame;
        frame.size.height=_svContainer.contentSize.height;
        frame.size.height=MIN(frame.size.height, _viewMaxHeight);
        _svContainer.frame=frame;
    }
    
    float oldHeight=self.frame.size.height;
    float newHeight=_svContainer.frame.size.height;
    
    if (self.translatesAutoresizingMaskIntoConstraints)
    {//autosizing
        {
            CGRect frame=self.frame;
            frame.size.height=newHeight;
            self.frame=frame;
        }
        if (!_isInit
            && oldHeight!= newHeight
            && _delegate) {
            [_delegate heightDidChangedTagView:self];
            
        }else{
            
        }
    }else
    {//auto layout
        if (oldHeight!= newHeight){
            _newHeight = newHeight;
            [self invalidateIntrinsicContentSize];
        }
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
    tagBtn.colorTagUnSelected=_colorTagUnselected;
    tagBtn.colorTagBorder=_colorTagBoard;
    
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
    _isInit=YES;
    for (NSString *tag in tags)
    {
        [self addTagToLast:tag];
    }
    [self layoutTagviews];
    _isInit=NO;
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
- (void)removeAllTags{
    _isInit=YES;
    [_tagStrings removeAllObjects];
    for (UIView* v in _tagArrows) {
        [v removeFromSuperview];
    }
    [_tagArrows removeAllObjects];
    for (UIButton* bt in _tagButtons) {
        [bt removeFromSuperview];
        
    }
    [_tagButtons removeAllObjects];
    [self layoutTagviews];
    _isInit=NO;
}
- (void)removeTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        [self removeTag:tag];
    }
    [self layoutTagviews];
}
- (void)removeTagWithIndex:(NSInteger)index{
    [self removeTag:_tagStrings[index]];
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
        case EYTagView_Type_Edit_Only_Delete:
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
                tagButton.colorBg=_colorTagBg;
                tagButton.selected=YES;
            }
        }
            break;
        case EYTagView_Type_Multi_Selected:
        {
            tagButton.selected=!tagButton.selected;
            //如果有标签数量选择限制
            if (_maxSelected != 0) {
                if (tagButton.selected == YES) {
                    _tagButtonSelecteds += 1;
                }else if(tagButton.selected == NO){
                    _tagButtonSelecteds -= 1;
                }
                if (_tagButtonSelecteds > _maxSelected) {
                    tagButton.selected=!tagButton.selected;
                    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"您最多只能选择%ld个标签",_maxSelected] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    _tagButtonSelecteds -= 1;
                }
            }
        }
            break;
        case EYTagView_Type_Multi_Selected_Edit:
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

-(void)finishEditing{
    if ((_type==EYTagView_Type_Edit || _type==EYTagView_Type_Multi_Selected_Edit) &&
        _tfInput.isFirstResponder && _tfInput.text) {
        NSString* pureStr=[_tfInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (pureStr
            && ![pureStr isEqualToString:@""]) {
            [self addTagToLast:pureStr];
            _tfInput.text=nil;
            [self layoutTagviews];
            
        }
    }
    [self.tfInput resignFirstResponder];
}

-(NSArray *)getTagTexts{
    NSMutableArray *texts = [NSMutableArray array];
    for (UIButton *bt in self.tagButtons) {
        if (bt.selected) {
            [texts addObject:bt.titleLabel.text];
        }
    }
    return [NSArray arrayWithArray:texts];
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
    frame.size.width=MAX(frame.size.width, [EYLOCALSTRING(@"Add Tag") sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2);
    
    if (frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
        NSLog(@"!!!  _tfInput width tooooooooo large");
        return NO;
    }
    else{
        return YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(tagDidBeginEditing:)]) {
        [_delegate tagDidBeginEditing:self];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(tagDidEndEditing:)]) {
        [_delegate tagDidEndEditing:self];
    }
}
#pragma mark UIMenuController

- (void) deleteItemClicked:(id) sender {
    if (_delegate && [_delegate respondsToSelector:@selector(willRemoveTag:index:)]) {
        if ([_delegate willRemoveTag:self index:_editingTagIndex]) {
            [self removeTag:_tagStrings[_editingTagIndex]];
        }
    }
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
- (void)handlerTapGesture:(UIPanGestureRecognizer *)recognizer {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    if ((_type==EYTagView_Type_Edit || _type==EYTagView_Type_Multi_Selected_Edit)
        &&  _tfInput.isFirstResponder
        && _tfInput.text) {
        NSString* pureStr=[_tfInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (pureStr
            && ![pureStr isEqualToString:@""]) {
            [self addTagToLast:pureStr];
            _tfInput.text=nil;
            [self layoutTagviews];
            
        }
    }
}
#pragma mark getter & setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _svContainer.backgroundColor=backgroundColor;
}
-(void)setType:(EYTagView_Type)type{
    _type=type;
    if (_type==EYTagView_Type_Display
        || _type==EYTagView_Type_Flow) {
        self.userInteractionEnabled=NO;
    }else{
        self.userInteractionEnabled=YES;
    }
    
    switch (_type) {
        case EYTagView_Type_Edit:
        case EYTagView_Type_Edit_Only_Delete:
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
#pragma mark autolayout
-(CGSize)intrinsicContentSize{//UIViewNoIntrinsicMetric
    if (_numberOfLines==0) {
        return CGSizeMake(UIViewNoIntrinsicMetric, _newHeight);
    } else {
        return CGSizeMake((_tagPaddingSize.height+_tagHeight)*_numberOfLines+_tagPaddingSize.height, _newHeight);
    }
}
-(void)layoutSubviews{
    [self layoutTagviews];
}
@end
