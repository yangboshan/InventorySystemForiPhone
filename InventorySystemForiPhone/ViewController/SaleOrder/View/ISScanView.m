//
//  BCScanView.m
//  TripAway4Server
//
//  Created by yangboshan on 15/12/22.
//  Copyright (c) 2015年 yangbs. All rights reserved.
//

#import "ISScanView.h"

@interface ISScanView()
@property (nonatomic,strong) UIView*  scanLineView;
@end

@implementation ISScanView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *topView = [[UIView alloc]init];
        [topView setFrame:CGRectMake(0, 0, frame.size.width, 50)];
        [topView setBackgroundColor:[UIColor blackColor]];
        [topView setAlpha:0.3];
        [self addSubview:topView];
        
        UIView *leftView = [[UIView alloc]init];
        [leftView setFrame:CGRectMake(0, 50, 50, frame.size.height - 100)];
        [leftView setBackgroundColor:[UIColor blackColor]];
        [leftView setAlpha:0.3];
        [self addSubview:leftView];
        
        UIView *rightView = [[UIView alloc]init];
        [rightView setFrame:CGRectMake(frame.size.width - 50, 50, 50, frame.size.height - 100)];
        [rightView setBackgroundColor:[UIColor blackColor]];
        [rightView setAlpha:0.3];
        [self addSubview:rightView];
        
        UIView *buttomView = [[UIView alloc]init];
        [buttomView setFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 50)];
        [buttomView setBackgroundColor:[UIColor blackColor]];
        [buttomView setAlpha:0.3];
        [self addSubview:buttomView];
        
 
        [self addSubview:self.scanLineView];
 
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                          target:self
                                                        selector:@selector(startDrawRect)
                                                        userInfo:nil
                                                         repeats:YES];
        [timer fire];
    }
    return self;
}

- (void)startDrawRect{
    CGFloat org_y = self.scanLineView.frame.origin.y < self.frame.size.height - 50 ? self.scanLineView.frame.origin.y + 2 : 50;
    [self.scanLineView setFrame:CGRectMake(50,  org_y, self.scanLineView.frame.size.width, 5)];
}

- (UIView*)scanLineView{
    if (!_scanLineView) {
        _scanLineView = [[UIView alloc]init];
        [_scanLineView setFrame:CGRectMake(50, 50, self.frame.size.width - 100, 5)];
        [_scanLineView setBackgroundColor:[UIColor greenColor]];
        [_scanLineView setAlpha:0.5];
    }
    return _scanLineView;
}


- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    
    // left-up
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 50, 50);
    CGContextAddLineToPoint(context, 70, 50);
    CGContextMoveToPoint(context, 50, 50);
    CGContextAddLineToPoint(context, 50, 70);
    
    // right-up
    CGContextMoveToPoint(context, rect.size.width - 50, 50);
    CGContextAddLineToPoint(context, rect.size.width - 70, 50);
    CGContextMoveToPoint(context, rect.size.width - 50, 50);
    CGContextAddLineToPoint(context, rect.size.width - 50, 70);
    
    // left-down
    CGContextMoveToPoint(context, 50, rect.size.height - 50);
    CGContextAddLineToPoint(context, 70, rect.size.height - 50);
    CGContextMoveToPoint(context, 50, rect.size.height - 50);
    CGContextAddLineToPoint(context, 50, rect.size.height - 70);
    
    // right-down
    CGContextMoveToPoint(context, rect.size.width - 50, rect.size.height - 50);
    CGContextAddLineToPoint(context, rect.size.width - 70, rect.size.height - 50);
    CGContextMoveToPoint(context, rect.size.width - 50, rect.size.height - 50);
    CGContextAddLineToPoint(context, rect.size.width - 50, rect.size.height - 70);
    
    CGContextStrokePath(context);
}

@end
