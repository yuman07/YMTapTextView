//
//  YMTapTextView.m
//  YMTapLabel
//
//  Created by yuman on 2021/1/29.
//

#import "YMTapTextView.h"

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
        [self.rangesArray addObject:@[[NSValue valueWithRange:range], block]];
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
        NSArray *array = self.rangesArray[i];
        NSRange tmpRange = [array.firstObject rangeValue];
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
    
    for (NSArray *array in self.rangesArray) {
        NSRange range = [array.firstObject rangeValue];
        dispatch_block_t block = array.lastObject;
        
        if (range.location >= self.text.length) {
            continue;
        }
        
        NSRange tmp = self.selectedRange;
        self.selectedRange = range;
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = tmp;
        
        for (UITextSelectionRect *rect in rects) {
            if (CGRectContainsPoint(rect.rect, point)) {
                block();
                return;
            }
        }
    }
}

@end
