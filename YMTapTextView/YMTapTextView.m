//
//  YMTapTextView.m
//  YMTapLabel
//
//  Created by yuman on 2021/1/29.
//

#import "YMTapTextView.h"

static NSString * const kRangeKey  = @"kRangeKey";
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
        _rangesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTapActionWithRange:(NSRange)range block:(dispatch_block_t)block
{
    if (range.location == NSNotFound || range.length == 0 || !block) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_removeTapActionWithRange:range];
        [self.rangesArray addObject:@{
            kRangeKey  : [NSValue valueWithRange:range],
            kActionKey : block,
        }];
    });
}

- (void)removeTapActionWithRange:(NSRange)range
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_removeTapActionWithRange:range];
    });
}

- (void)p_removeTapActionWithRange:(NSRange)range
{
    for (NSInteger i = self.rangesArray.count - 1; i >= 0; i--) {
        NSDictionary *dic = [self.rangesArray objectAtIndex:i];
        NSRange tmpRange = [(NSValue *)[dic objectForKey:kRangeKey] rangeValue];
        if (NSEqualRanges(tmpRange, range)) {
            [self.rangesArray removeObjectAtIndex:i];
        }
    }
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
        NSRange range = [(NSValue *)[dic objectForKey:kRangeKey] rangeValue];
        dispatch_block_t block = [dic objectForKey:kActionKey];
        
        if (range.location >= self.text.length) {
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
