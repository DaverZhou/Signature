//
//  ViewController.m
//  SignatureDemo
//
//  Created by wbx on 2018/3/23.
//  Copyright © 2018年 DaverZhou. All rights reserved.
//

#import "ViewController.h"

#import "SignatureView.h"

#import "SignOtherView.h"


@interface ViewController ()

@property (nonatomic, strong) SignatureView * signatureV;


@property (nonatomic, strong) SignOtherView * otherV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //方法一：
//    _signatureV = [[SignatureView alloc] initWithFrame:self.view.bounds];
//
//    [self.view addSubview:_signatureV];
    
    //方法二：
    _otherV = [[SignOtherView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_otherV];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
