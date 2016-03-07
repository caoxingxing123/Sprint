//
//  UIPlaceHolderTextView.m
//  Tutu
//
//  Created by house365 on 12-1-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIPlaceHolderTextView.h"
#import "Common.h"
#import "MacroDef.h"

static NSString *kPlaceholderKey = @"placeholder";
static NSString *kFontKey = @"font";
static NSString *kTextKey = @"text";
static float kUITextViewPadding = 8.0;
@implementation UIPlaceHolderTextView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:kPlaceholderKey];
    [self removeObserver:self forKeyPath:kFontKey];
    [self removeObserver:self forKeyPath:kTextKey];
}

- (void)awakeFromNib
{
    self.delegate = self;
    [super awakeFromNib];
    [self setPlaceholderColor:[UIColor colorWithWhite:0.76 alpha:1.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self addObserver:self forKeyPath:kPlaceholderKey
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kFontKey
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kTextKey
              options:NSKeyValueObservingOptionNew context:nil];
    
    CGRect frame = CGRectMake(5, kUITextViewPadding, 0, 0);
    self.placeholderLabel = [[UILabel alloc] initWithFrame:frame];
    self.placeholderLabel.opaque = NO;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.textColor = [Common colorFromHexRGB:@"cccccc"];
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.placeholderLabel.font = self.font;
    [self.placeholderLabel sizeToFit];
    [self addSubview:self.placeholderLabel];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kPlaceholderKey]) {
        self.placeholderLabel.text = [change valueForKey:NSKeyValueChangeNewKey];
        [self.placeholderLabel sizeToFit];
    }
    else if ([keyPath isEqualToString:kFontKey]) {
        self.placeholderLabel.font = [change valueForKey:NSKeyValueChangeNewKey];
        [self.placeholderLabel sizeToFit];
    }
    else if ([keyPath isEqualToString:kTextKey]) {
        NSString *newText = [change valueForKey:NSKeyValueChangeNewKey];
        if (newText.length > 0) {
            [self.placeholderLabel removeFromSuperview];
        } else {
            [self addSubview:self.placeholderLabel];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (id)initWithFrame:(CGRect)frame
{
     if( (self = [super initWithFrame:frame]) )
    {
        self.delegate = self;
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor colorWithWhite:0.76 alpha:1.0]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndEdit:) name:UITextViewTextDidEndEditingNotification object:nil];
        [self addObserver:self forKeyPath:kPlaceholderKey
                  options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:kFontKey
                  options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:kTextKey
                  options:NSKeyValueObservingOptionNew context:nil];
        
        CGRect frame = CGRectMake(5, kUITextViewPadding, 0, 0);
        self.placeholderLabel = [[UILabel alloc] initWithFrame:frame];
        self.placeholderLabel.opaque = NO;
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
        self.placeholderLabel.textColor = [Common colorFromHexRGB:@"cccccc"];
        self.placeholderLabel.textAlignment = self.textAlignment;
        self.placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.placeholderLabel.font = self.font;
        [self.placeholderLabel sizeToFit];
        [self addSubview:self.placeholderLabel];
    }
    return self;
}



- (void)textEndEdit:(NSNotification *)notification
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIEdgeInsets inset = self.contentInset;
    CGRect frame = self.placeholderLabel.frame;
    frame.size.width = self.bounds.size.width;
    frame.size.width-= kUITextViewPadding + inset.right + inset.left;
    self.placeholderLabel.frame = frame;
    if (self.layRight) {
        self.placeholderLabel.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    self.placeholderLabel.textColor = placeholderTextColor;
}

- (UIColor *)placeholderTextColor
{
    return self.placeholderLabel.textColor;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.scrollEnabled = YES;
    self.isBeyond = NO;
    if (self.textViewShouldBeginEditingBlock) {
        self.textViewShouldBeginEditingBlock(textView);
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textViewShouldEndEditingBlock) {
        self.textViewShouldEndEditingBlock(textView);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textViewDidBeginEditingBlock) {
        self.textViewDidBeginEditingBlock(textView);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([self isLong:textView.text]) {
        self.isBeyond = YES;
    }
    if (self.textViewDidEndEditingBlock) {
        self.textViewDidEndEditingBlock (textView);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [self endEditing:YES];
//    }
//    if([text isEqualToString:NullString]){
//        return YES;
//    }
//    NSLog(@"shouldChangeTextInRange: %@",textView.text);
    if (self.shouldChangeTextInRangeBlock) {
        return self.shouldChangeTextInRangeBlock(textView, range, text);
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.text.length < 1) {
        [self addSubview:self.placeholderLabel];
        [self sendSubviewToBack:self.placeholderLabel];
    } else {
        [self.placeholderLabel removeFromSuperview];
    }
//    NSLog(@"textViewDidChange: %@",textView.text);
    if (textView.text.length > self.maxLengh) {
        
    }
    if (self.textViewDidChangeBlock) {
        self.textViewDidChangeBlock(textView);
    }
    //计算高度
    if(self.textViewFrameSetHeight){
        self.textViewFrameSetHeight(self,[self flotTextHeight:textView.text]);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
//    NSLog(@"textViewDidChangeSelection textView.text = %@", textView.text);
   // textView.text = @"nihao";
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
//    NSLog(@"shouldInteractWithURL textView.text = %@", textView.text);
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
//    NSLog(@"shouldInteractWithTextAttachment textView.text = %@", textView.text);
    return YES;
}
- (BOOL)isLong:(NSString *)string {
    NSInteger countEng = 0;
    NSInteger countLengh = self.maxLengh+1;
    for (int i = 0; i < string.length; i++) {
        int chr = [string characterAtIndex:i];
        if ((chr >= 0x4e00 && chr <= 0x9fff) || (chr > 0x0040 && chr < 0x005b)) {
            countLengh--;
        } else {
            countEng++;
            if (countEng%2 != 0) {
                countLengh--;
            } else if (countEng%2 == 0) {
                countEng = 0;
            }
        }
        if (countLengh == 0) {
            self.location = i;
            return YES;
        }
    }
    if (countLengh > 0) return NO;
    return YES;
}
- (float)flotTextHeight:(NSString *)textstr
{
    float heigh = 0.0;
    if(isIOS7){
        CGRect s = [textstr boundingRectWithSize:CGSizeMake(self.frame.size.width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
        heigh = s.size.height;
    }
    //ios6
    else{
//        CGSize z = [textstr sizeWithFont:self.font
//                                    constrainedToSize:Size(self.frame.Width, MAXFLOAT)lineBreakMode:NSLineBreakByWordWrapping];
//        heigh = z.height;
        
    }
    return heigh;
}
@end