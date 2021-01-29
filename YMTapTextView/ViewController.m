//
//  ViewController.m
//  YMTapTextView
//
//  Created by yuman on 2021/1/29.
//

#import "ViewController.h"
#import "YMTapTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YMTapTextView *textView = [[YMTapTextView alloc] initWithFrame:CGRectMake(100, 100, 100, 0)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"本人确认阅读并同意签署《业务委托书》及《个人信息采集及征信查询授权书》"];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:18]
                   range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor orangeColor]
                   range:NSMakeRange(11, 7)];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor orangeColor]
                   range:NSMakeRange(19, 16)];
    textView.attributedText = string;
    
    [textView sizeToFit];
    
    [self.view addSubview:textView];
    
    [textView addTapActionWithRange:NSMakeRange(11, 7) block:^{
        NSLog(@"点击了《业务委托书》");
    }];
    
    [textView addTapActionWithRange:NSMakeRange(19, 16) block:^{
        NSLog(@"点击了《个人信息采集及征信查询授权书》");
    }];
    
}


@end
