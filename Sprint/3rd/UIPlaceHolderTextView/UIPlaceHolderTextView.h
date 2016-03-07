//
//  UIPlaceHolderTextView.h
//  Tutu
//
//  Created by house365 on 12-1-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDef.h"

typedef void(^TextViewShouldBeginEditingBlock)(UITextView *textView);
typedef void(^TextViewShouldEndEditingBlock)(UITextView *textView);
typedef void(^TextViewDidBeginEditingBlock)(UITextView *textView);
typedef void(^TextViewDidEndEditingBlock)(UITextView *textView);
typedef void(^TextViewDidChangeBlock)(UITextView *textView);
typedef void(^TextViewFrameSetHeight)(UITextView *textView,float heigt);
typedef BOOL(^ShouldChangeTextInRangeBlock)(UITextView *textView, NSRange range, NSString *text);
@interface UIPlaceHolderTextView : UITextView<UITextViewDelegate> {
}

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
Assign BOOL layRight;
Assign BOOL isBeyond;
Assign NSInteger maxLengh;
Assign NSInteger minLengh;
Assign NSInteger location;
Copy TextViewShouldBeginEditingBlock textViewShouldBeginEditingBlock;
Copy TextViewShouldEndEditingBlock textViewShouldEndEditingBlock;
Copy TextViewDidBeginEditingBlock textViewDidBeginEditingBlock;
Copy TextViewDidEndEditingBlock textViewDidEndEditingBlock;
Copy TextViewDidChangeBlock textViewDidChangeBlock;
Copy ShouldChangeTextInRangeBlock shouldChangeTextInRangeBlock;
Copy TextViewFrameSetHeight textViewFrameSetHeight;
-(void)textChanged:(NSNotification*)notification;

- (BOOL)isLong:(NSString *)string;

@end
