//
//  ViewController.m
//  Part6
//
//  Created by 薛尧 on 16/10/7.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "ViewController.h"

#import "MsgSend.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /**
     *  objc_msgSend
     *
     *  从这个函数的注释可以看出来了，这是个最基本的用于发送消息的函数。另外，这个函数并不能发送所有类型的消息，只能发送基本的消息。
     *  比如，在一些处理器上，我们必须使用objc_msgSend_stret来发送返回值类型为结构体的消息，使用objc_msgSend_fpret来发送返回值类型为浮点类型的消息，而又在一些处理器上，还得使用objc_msgSend_fp2ret来发送返回值类型为浮点类型的消息。
     *  最关键的一点：无论何时，要调用objc_msgSend函数，必须要将函数强制转换成合适的函数指针类型才能调用。
     *  从objc_msgSend函数的声明来看，它应该是不带返回值的，但是我们在使用中却可以强制转换类型，以便接收返回值。另外，它的参数列表是可以任意多个的，前提也是要强制函数指针类型。
     */
    
    [MsgSend test];
}


















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
