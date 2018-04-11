//
//  SignOtherView.m
//  TestDemo
//
//  Created by wbx on 2018/3/23.
//  Copyright © 2018年 DaverZhou. All rights reserved.
//

#import "SignOtherView.h"
#import <QuartzCore/QuartzCore.h>

@interface SignOtherView ()

@property (nonatomic, strong) UIBezierPath *beizerPath;

@property (nonatomic, assign) CGPoint previousPoint;

@end
static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}



@implementation SignOtherView

- (void)commonInit {
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self setMultipleTouchEnabled:NO];
    
    _beizerPath = [UIBezierPath bezierPath];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self commonInit];
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    
    [_beizerPath moveToPoint:currentPoint];
    
    _previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    
    CGPoint midPoint = midpoint(_previousPoint, currentPoint);
    
    [_beizerPath addQuadCurveToPoint:midPoint controlPoint:_previousPoint];
    
    _previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    
    [_beizerPath stroke];
}

#pragma mark -- 清除签名
- (void)clearSignature
{
    [_beizerPath removeAllPoints];
    
    [self setNeedsDisplay];
}
#pragma mark - 获取图片
- (UIImage *)getSignatureImage
{
    //设置为NO，UIView是透明这里的图片就是透明的
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents/Image", NSHomeDirectory()];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/Image/Signature.PNG", NSHomeDirectory()];
    
    //用png是透明的
    [UIImagePNGRepresentation(signatureImage) writeToFile: path atomically:YES];
    
    return signatureImage;
}

@end
