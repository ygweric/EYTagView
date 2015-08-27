//
//  EYTextField.m
//  EYPopupView_Example
//
//  Created by ericyang on 8/14/15.
//  Copyright (c) 2015 Eric Yang. All rights reserved.
//

#import "EYTextField.h"

@implementation EYTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 9 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 9 , 0 );
}

@end
