//
//  EqualizerCustomView.m
//  iOSCustomEqualizer
//
//  Created by Elton Mendes Vieira Junior on 4/8/15.
//  Copyright (c) 2015 Mendes. All rights reserved.
//

#import "EqualizerCustomView.h"

@interface EqualizerCustomView ()

@property (nonatomic,strong) IBInspectable UIColor *waveColor;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat waveNumbers;
@property (nonatomic) IBInspectable CGFloat waveSpace;
@property (nonatomic) IBInspectable CGFloat waveSpeed;
@end

@implementation EqualizerCustomView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    self.layer.masksToBounds = YES;
    CGFloat waveSize = (self.frame.size.width / self.waveNumbers);
    
    for (NSInteger waves = 0; waves < self.waveNumbers; waves++) {
        //// Rectangle Drawing
        CGRect waveRectangleRect = CGRectMake((waves * waveSize) + (self.waveSpace / 2),
                                              self.frame.size.height,
                                              waveSize - self.waveSpace,
                                              self.frame.size.height);
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:waveRectangleRect];
        
        CAShapeLayer *waveLayer = [CAShapeLayer layer];
        waveLayer.fillColor = self.waveColor.CGColor;
        waveLayer.strokeColor = self.borderColor.CGColor;
        waveLayer.path = rectanglePath.CGPath;
        [self.layer addSublayer:waveLayer];
        
        [self animateLayer:waveLayer];
    }
}

#pragma mark - Private Methods

//Wave Animation
- (void)animateLayer:(CAShapeLayer *)layer {
    CGFloat randomHeight = arc4random_uniform(self.frame.size.height);
    CGPoint fromValue = [layer.presentationLayer position];
    CGPoint toValue = CGPointMake(fromValue.x, -randomHeight);
    
    
    CABasicAnimation *animation = [CABasicAnimation
                                   animationWithKeyPath:@"position"];
    animation.duration = self.waveSpeed;
    animation.fromValue = [NSValue valueWithCGPoint:fromValue];
    animation.toValue = [NSValue valueWithCGPoint:toValue];
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CATransaction
                                animationTimingFunction];
    [layer addAnimation:animation forKey:@"position"];
    
    __weak id weakSelf = self;
    __weak CAShapeLayer *weakLayer = layer;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.waveSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf animateLayer:weakLayer];
    });
}


@end
