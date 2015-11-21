//
//  ViewController.m
//  CoreTextDemo
//
//  Created by jamalping on 15/11/16.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import "ViewController.h"
#import "CTDisPlayView.h"

@interface ViewController ()

@end

@implementation ViewController
void sayHello() {
    NSLog(@"sayHello");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CTDisPlayView *ctView = [[CTDisPlayView alloc] init];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = 300;
    config.textColor = [UIColor redColor];
    config.fontSize = 14;
    config.lineSpace = 20;
    
//    ctView.data = [CTFrameParser parserContentString:@"今天是个好日子啊，今天又是个好日子" config:config];
    ctView.data = [CTFrameParser parserTemplateFile:[[NSBundle mainBundle] pathForResource:@"ImageAndTextFile" ofType:nil] config:config];
    ctView.frame = CGRectMake(0, 100, self.view.frame.size.width, ctView.data.height);
    ctView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:ctView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.navigationController.navigationBarHidden = button.selected;
}

@end
