//
//  EYTagView.h
//  EYTagView_Example
//
//  Created by ericyang on 8/9/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//

#import <UIKit/UIKit.h>



#define COLORRGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:a]
#define COLORRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]



#define _K_SCREEN_WIDTH ([[UIScreen mainScreen ] bounds ].size.width)

#ifndef DEBUG_LOG
#define DEBUG_LOG
#define LOGERROR NSLog(@"error !!!!!!!!! %s,%d",__FUNCTION__,__LINE__);
#define LOGWARNING NSLog(@"warning %s,%d",__FUNCTION__,__LINE__);
#define LOGERRORMSG(msg) NSLog(@"error:%@ %s,%d",msg,__FUNCTION__,__LINE__);
#define LOGLINE NSLog(@"info %s,%d",__FUNCTION__,__LINE__);
#define LOGINFO(format,value)  NSLog([NSString stringWithFormat:@"%@ ; info %%s,%%d",format],value,__FUNCTION__,__LINE__);
#define LOGTEXT(value)  NSLog(@"%@ ; info %s,%d",value,__FUNCTION__,__LINE__);
#define LOGTODO NSLog(@"TODO !!!!! ; info %s,%d",__FUNCTION__,__LINE__);
#define LOGTIME NSLog(@"%f %s,%d",[[NSDate date]timeIntervalSince1970],__FUNCTION__,__LINE__);

#define LOGNOTHING(format,value)
#endif

@class EYTagView;
@protocol EYTagViewDelegate <NSObject>

@optional
-(void)heightDidChangedTagView:(EYTagView*)tagView;

@end

typedef enum{
    EYTagView_Type_Edit,
    EYTagView_Type_Display,
    EYTagView_Type_Single_Selected,
    EYTagView_Type_Multi_Selected,
}EYTagView_Type;

@interface EYTagView : UIView
@property (nonatomic, strong) id<EYTagViewDelegate> delegate;
@property (nonatomic, strong) UITextField* tfInput;
@property (nonatomic) EYTagView_Type type;//default edit

@property (nonatomic) float tagWidht;//default
@property (nonatomic) float tagHeight;//default

@property (nonatomic) float viewMaxHeight;

@property (nonatomic) CGSize tagPaddingSize;//top & left
@property (nonatomic) CGSize textPaddingSize;


@property (nonatomic, strong) UIFont* fontTag;
@property (nonatomic, strong) UIFont* fontInput;


@property (nonatomic, strong) UIColor* colorTag;
@property (nonatomic, strong) UIColor* colorInput;
@property (nonatomic, strong) UIColor* colorInputPlaceholder;

@property (nonatomic, strong) UIColor* colorTagBg;
@property (nonatomic, strong) UIColor* colorInputBg;
@property (nonatomic, strong) UIColor* colorInputBoard;


- (void)addTags:(NSArray *)tags;
- (void)addTags:(NSArray *)tags selectedTags:(NSArray*)selectedTags;
-(void)layoutTagviews;
-(void)setTagStringsSelected:(NSMutableArray *)tagStringsSelected;
-(NSMutableArray *)tagStrings;
@end
