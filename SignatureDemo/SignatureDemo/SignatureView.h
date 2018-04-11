//
//  SignatureView.h
//  TestDemo
//
//  Created by wbx on 2018/3/23.
//  Copyright © 2018年 DaverZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView

#pragma mark -- 清除签名
- (void)clearSignature;

#pragma mark - 获取图片
- (UIImage *)getSignatureImage;

@end
