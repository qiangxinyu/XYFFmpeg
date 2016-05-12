//
//  ViewController.m
//  XYFFmpeg
//
//  Created by Xinyu Qiang on 16/5/11.
//  Copyright © 2016年 Xinyu Qiang. All rights reserved.
//

#import "ViewController.h"

#include "avcodec.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     avcodec_register_all();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
