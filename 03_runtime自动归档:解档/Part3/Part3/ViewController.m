//
//  ViewController.m
//  Part3
//
//  Created by 薛尧 on 16/9/20.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "ViewController.h"

#import "ArchiveModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [ArchiveModel test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
