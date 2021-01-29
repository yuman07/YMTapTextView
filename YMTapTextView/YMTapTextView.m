//
//  YMTapTextView.m
//  YMTapLabel
//
//  Created by yuman on 2021/1/29.
//

#import "YMTapTextView.h"

static NSString * const kRangeKey = @"kRangeKey";
static NSString * const kActionKey = @"kActionKey";

@interface YMTapTextView ()

@property (nonatomic, strong) NSMutableArray *rangesArray;

@end

@implementation YMTapTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.selectable = NO;
        _rangesArray = [NSMutableArray array];
    }
    return self;
}

- (void)addTapActionWithRange:(NSRange)range block:(dispatch_block_t)block
{
    if (range.location == NSNotFound || range.length == 0 || !block) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rangesArray addObject:@{
            kRangeKey  : [NSValue valueWithRange:range],
            kActionKey : block,
        }];
    });
}

- (void)removeAllTapAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rangesArray removeAllObjects];
    });
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    for (NSDictionary *dic in self.rangesArray) {
        NSRange range = [((NSValue *)[dic objectForKey:kRangeKey]) rangeValue];
        dispatch_block_t block = [dic objectForKey:kActionKey];
        
        if (self.text.length == 0 || range.location > self.text.length - 1) {
            continue;
        }
        
        NSRange tmp = self.selectedRange;
        self.selectedRange = range;
        NSArray *array = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = tmp;
        
        for (UITextSelectionRect *rect in array) {
            if (CGRectContainsPoint(rect.rect, point)) {
                block();
                return;
            }
        }
    }
}

@end
