//
//  YMTapTextView.h
//  YMTapLabel
//
//  Created by yuman on 2021/1/29.
//

#import <UIKit/UIKit.h>

@interface YMTapTextView : UITextView

/// 给指定Range的文字添加点击事件
/// @param range 该段文字在总文本的范围
/// @param block 点击后执行的操作，在主线程执行
- (void)addTapActionWithRange:(NSRange)range block:(dispatch_block_t)block;

/// 删除所有已添加的点击事件
- (void)removeAllTapAction;

@end
