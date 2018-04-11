//
//  SignatureView.m
//  TestDemo
//
//  Created by wbx on 2018/3/23.
//  Copyright © 2018年 DaverZhou. All rights reserved.
//

#import "SignatureView.h"

@interface SignatureView ()
{
    CGPoint points[5];
}
//
@property(nonatomic,assign) NSInteger control;

@property(nonatomic,strong) UIBezierPath *beizerPath;

@end


@implementation SignatureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //关闭多点触控
        [self setMultipleTouchEnabled:NO];
        
        _beizerPath = [UIBezierPath bezierPath];
        
        [_beizerPath setLineWidth:2];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //设置签名的颜色
    UIColor *strokeColor = [UIColor redColor];
    
    [strokeColor setStroke];
    
    //签名的路径绘制
    [_beizerPath stroke];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _control = 0;
    
    UITouch *touch = [touches anyObject];
    
    points[0] = [touch locationInView:self];
    
    CGPoint startPoint = points[0];
    
    CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y + 2);
    
    [_beizerPath moveToPoint:startPoint];
    
    [_beizerPath addLineToPoint:endPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    _control ++;
    
    points[_control] = touchPoint;
    
    if (_control == 4){
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        
        //设置画笔起始点
        [_beizerPath moveToPoint:points[0]];
        
        //endPoint终点 controlPoint1、controlPoint2控制点
        [_beizerPath addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        //setNeedsDisplay会自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了
        [self setNeedsDisplay];
        
        points[0] = points[3];
        
        points[1] = points[4];
        
        _control = 1;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
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
