//
//  YRSideViewController.m
//  YRSnippets
//
//  Created by 王晓宇 on 14-5-10.
//  Copyright (c) 2014年 王晓宇. All rights reserved.
//

#import "YRSideViewController.h"
#import "SPTContentViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YRSideViewController ()<UIGestureRecognizerDelegate>{
    UIView *_baseView;//目前是_baseView
    UIView *_currentView;//其实就是rootViewController.view
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    CGPoint _startPanPoint;
    CGPoint _lastPanPoint;
    BOOL _panMovingRightOrLeft;//true是向右，false是向左
    
    UIButton *_coverButton;
}

@end

@implementation YRSideViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftViewShowWidth = 267;
        _rightViewShowWidth = 267;
        _animationDuration = 0.35;
        _showBoundsShadow = true;

        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [_panGestureRecognizer setDelegate:self];

        _panMovingRightOrLeft = false;
        _lastPanPoint = CGPointZero;

        _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        [_coverButton setBackgroundColor:[UIColor greenColor]];
        [_coverButton addTarget:self action:@selector(hideSideViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)init{
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _baseView              = self.view;
    [_baseView setBackgroundColor:[UIColor colorWithPatternImage:Image(@"loginBg.png")]];
    self.needRightSide = YES;
    self.needLeftSide = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.rootViewController) {
        NSAssert(false, @"you must set rootViewController!!");
    }
    if (_currentView!=_rootViewController.view) {
        [_currentView removeFromSuperview];
        _currentView=_rootViewController.view;
        [_baseView addSubview:_currentView];
        _currentView.frame=_baseView.bounds;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRootViewController:(UIViewController *)rootViewController{
    if (_rootViewController!=rootViewController) {
        if (_rootViewController) {
            [_rootViewController removeFromParentViewController];
        }
        _rootViewController=rootViewController;
        if (_rootViewController) {
            [self addChildViewController:_rootViewController];
        }
    }
}
-(void)setLeftViewController:(UIViewController *)leftViewController{
    if (_leftViewController!=leftViewController) {
        if (_leftViewController) {
            [_leftViewController removeFromParentViewController];
        }
        _leftViewController=leftViewController;
        if (_leftViewController) {
            [self addChildViewController:_leftViewController];
        }
    }
}
-(void)setRightViewController:(UIViewController *)rightViewController{
    if (_rightViewController!=rightViewController) {
        if (_rightViewController) {
            [_rightViewController removeFromParentViewController];
        }
        _rightViewController=rightViewController;
        if (_rightViewController) {
            [self addChildViewController:_rightViewController];
        }
    }
}


- (void)setSwipeShowMenuLeft:(BOOL)needLeftSwipe Right:(BOOL)needRightSwipe {
    if (!_baseView) {
        _baseView = self.view;
    }
    [_baseView addGestureRecognizer:_panGestureRecognizer];
    self.needLeftSide = needLeftSwipe;
    self.needRightSide = needRightSwipe;
}

- (void)showShadow:(BOOL)show{
    _currentView.layer.shadowOpacity    = show ? 0.8f : 0.0f;
    if (show) {
        _currentView.layer.cornerRadius = 4.0f;
        _currentView.layer.shadowOffset = CGSizeZero;
        _currentView.layer.shadowRadius = 4.0f;
        _currentView.layer.shadowPath   = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
}
#pragma mark  ShowOrHideTheView
- (void)willShowLeftViewController{
    [self.view endEditing:YES];
    self.isShowLeftViewController = YES;
    self.isShowRightViewController = NO;
    if (![_currentView.subviews containsObject:_coverButton]) {
        [_currentView addSubview:_coverButton];
    }
    if (!_leftViewController || _leftViewController.view.superview) {
        return;
    }
    _leftViewController.view.frame=_baseView.bounds;
    [_baseView insertSubview:_leftViewController.view belowSubview:_currentView];
    if (_rightViewController && _rightViewController.view.superview) {
        [_rightViewController.view removeFromSuperview];
    }
}
- (void)willShowRightViewController{
    [self.view endEditing:YES];
    self.isShowRightViewController = YES;
    self.isShowLeftViewController = NO;
    if (![_currentView.subviews containsObject:_coverButton]) {
        [_currentView addSubview:_coverButton];
    }
    if (!_rightViewController || _rightViewController.view.superview) {
        return;
    }
    _rightViewController.view.frame=_baseView.bounds;
    [_baseView insertSubview:_rightViewController.view belowSubview:_currentView];
    if (_leftViewController && _leftViewController.view.superview) {
        [_leftViewController.view removeFromSuperview];
    }
}
- (void)showLeftViewController:(BOOL)animated{
    [self.view endEditing:YES];
    self.isShowLeftViewController = YES;
    self.isShowRightViewController = NO;
    if (![_currentView.subviews containsObject:_coverButton]) {
        [_currentView addSubview:_coverButton];
    }
    [self.view endEditing:YES];
    if (!_leftViewController) {
        return;
    }
    [self willShowLeftViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_leftViewShowWidth - _currentView.frame.origin.x) / _leftViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    WeakSelf;
    [UIView animateWithDuration:animatedTime animations:^{
        [wself layoutCurrentViewWithOffset:_leftViewShowWidth];
        if (![_currentView.subviews containsObject:_coverButton]) {
            [_currentView addSubview:_coverButton];
        }
        [wself showShadow:_showBoundsShadow];
    }];
}
- (void)showRightViewController:(BOOL)animated{
    [self.view endEditing:YES];
    self.isShowRightViewController = YES;
    self.isShowLeftViewController = NO;
    if (![_currentView.subviews containsObject:_coverButton]) {
        [_currentView addSubview:_coverButton];
    }
    if (!_rightViewController) {
        return;
    }
    [self willShowRightViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_rightViewShowWidth + _currentView.frame.origin.x) / _rightViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    WeakSelf;
    [UIView animateWithDuration:animatedTime animations:^{
        [wself layoutCurrentViewWithOffset:-_rightViewShowWidth];
        if (![_currentView.subviews containsObject:_coverButton]) {
            [_currentView addSubview:_coverButton];
        }
        [wself showShadow:_showBoundsShadow];
    }];
}

- (void)hideSideViewController:(BOOL)animated {
    self.isShowRightViewController = NO;
    self.isShowLeftViewController = NO;
    [self showShadow:false];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_currentView.frame.origin.x / (_currentView.frame.origin.x>0?_leftViewShowWidth:_rightViewShowWidth)) * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    WeakSelf;
    [UIView animateWithDuration:animatedTime animations:^{
        [wself layoutCurrentViewWithOffset:0];
    } completion:^(BOOL finished) {
        [_coverButton removeFromSuperview];
        [_leftViewController.view removeFromSuperview];
        [_rightViewController.view removeFromSuperview];
    }];
}

- (void)hideSideViewController{
    [self hideSideViewController:YES];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == _panGestureRecognizer) {
        CGPoint touchPoint = [touch locationInView:gestureRecognizer.view];
        if (touchPoint.x <= 50.0 || touchPoint.x >= 270.0) {
            return YES;
        }
        return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Check for horizontal pan gesture
    if (gestureRecognizer == _panGestureRecognizer) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:_baseView];
        CGPoint velocity = [panGesture velocityInView:_baseView];
        if ([panGesture velocityInView:_baseView].x < 600 && ABS(translation.x)/ABS(translation.y) > 1) {
            if (self.needRightSide && self.needLeftSide) {
                if (!self.isShowLeftViewController && !self.isShowRightViewController) {
                    return YES;
                } else if (velocity.x < 0 && (self.isShowLeftViewController && !self.isShowRightViewController)) {
                    return YES;
                } else if (velocity.x >= 0 && (!self.isShowLeftViewController && self.isShowRightViewController)) {
                    return YES;
                } else {
                    return NO;
                }
            } else if (!self.needLeftSide && self.needRightSide) {
                if (!self.isShowLeftViewController && !self.isShowRightViewController && velocity.x < 0) {
                    return YES;
                } else if (velocity.x >= 0 && (!self.isShowLeftViewController && self.isShowRightViewController)) {
                    return YES;
                } else {
                    return NO;
                }
            } else if (self.needLeftSide && !self.needRightSide) {
                if (!self.isShowLeftViewController && !self.isShowRightViewController && velocity.x >= 0) {
                    return YES;
                } else if (velocity.x < 0 && (self.isShowLeftViewController && !self.isShowRightViewController)) {
                    return YES;
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        }
        return NO;
    }
    return YES;
}

- (void)pan:(UIPanGestureRecognizer*)pan{
    if (_panGestureRecognizer.state==UIGestureRecognizerStateBegan) {
        _startPanPoint=_currentView.frame.origin;
        if (_currentView.frame.origin.x==0) {
            [self showShadow:_showBoundsShadow];
        }
        CGPoint velocity=[pan velocityInView:_baseView];
        if(velocity.x>0){
            if (_currentView.frame.origin.x>=0 && _leftViewController && !_leftViewController.view.superview) {
                [self willShowLeftViewController];
            } else {
                self.isShowLeftViewController = NO;
                self.isShowRightViewController = NO;
                [_coverButton removeFromSuperview];
            }
        }
        else if (velocity.x<0) {
            if (_currentView.frame.origin.x<=0 && _rightViewController && !_rightViewController.view.superview) {
                [self willShowRightViewController];
            } else {
                self.isShowLeftViewController = NO;
                self.isShowRightViewController = NO;
                [_coverButton removeFromSuperview];
            }
        }
        return;
    }
    CGPoint currentPostion = [pan translationInView:_baseView];
    CGFloat xoffset = _startPanPoint.x + currentPostion.x;
    if (xoffset>0) {//向右滑
        if (_leftViewController && _leftViewController.view.superview) {
            xoffset = xoffset>_leftViewShowWidth?_leftViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }else if(xoffset<0){//向左滑
        if (_rightViewController && _rightViewController.view.superview) {
            xoffset = xoffset<-_rightViewShowWidth?-_rightViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }
    if (xoffset!=_currentView.frame.origin.x) {
        [self layoutCurrentViewWithOffset:xoffset];
    }
    if (_panGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        if (_currentView.frame.origin.x!=0 && _currentView.frame.origin.x!=_leftViewShowWidth && _currentView.frame.origin.x!=-_rightViewShowWidth) {
            if (_panMovingRightOrLeft && _currentView.frame.origin.x>20) {
                [self showLeftViewController:YES];
            }else if(!_panMovingRightOrLeft && _currentView.frame.origin.x<-20){
                [self showRightViewController:YES];
            }else{
                [self hideSideViewController];
            }
        } else if (_currentView.frame.origin.x==0) {
            self.isShowLeftViewController = NO;
            self.isShowRightViewController = NO;
            [_coverButton removeFromSuperview];
            [self showShadow:NO];
        }
        _lastPanPoint = CGPointZero;
    }else{
        CGPoint velocity = [pan velocityInView:_baseView];
        if (velocity.x>0) {
            _panMovingRightOrLeft = YES;
        }else if(velocity.x<0){
            _panMovingRightOrLeft = NO;
        }
    }
}

//重写此方法可以改变动画效果,PS._currentView就是RootViewController.view
- (void)layoutCurrentViewWithOffset:(CGFloat)xoffset{
    if (_showBoundsShadow) {
        _currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
    if (self.rootViewMoveBlock) {//如果有自定义动画，使用自定义的效果
        self.rootViewMoveBlock(_currentView,_baseView.bounds,xoffset);
        return;
    }
    [_currentView setFrame:CGRectMake(xoffset, _baseView.bounds.origin.y, _baseView.frame.size.width, _baseView.frame.size.height)];
    return;
    /*平移的动画
     [_currentView setFrame:CGRectMake(xoffset, _baseView.bounds.origin.y, _baseView.frame.size.width, _baseView.frame.size.height)];
    return;
    //*/
    
//    /*平移带缩放效果的动画
//    static CGFloat h2w = 0.0;
//    if (h2w==0) {
//        h2w = _baseView.frame.size.height/_baseView.frame.size.width;
//    }
    CGFloat scale = ABS(600 - ABS(xoffset)) / 600;
    scale = MAX(0.5, scale);
    _currentView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat totalWidth=_baseView.frame.size.width;
    CGFloat totalHeight=_baseView.frame.size.height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        totalHeight=_baseView.frame.size.width;
        totalWidth=_baseView.frame.size.height;
    }
    
    if (xoffset>0) {//向右滑的
        [_currentView setFrame:CGRectMake(xoffset, _baseView.bounds.origin.y + (totalHeight * (1 - scale) / 2) + 24.0, totalWidth * scale, totalHeight * scale)];
    } else if (xoffset == 0) {
        [_currentView setFrame:[SingletonApplication keyWindow].bounds];
    } else{//向左滑的
        [_currentView setFrame:CGRectMake(_baseView.frame.size.width * (1 - scale) + xoffset, _baseView.bounds.origin.y + (totalHeight*(1 - scale) / 2) + 24.0, totalWidth * scale, totalHeight * scale)];
    }
}

@end
