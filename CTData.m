//
//  CTData.m
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import "CTData.h"

@implementation CTData

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        _ctFrame = ctFrame;
        CFRetain(_ctFrame);
    }
}


- (void)setImageArray:(NSMutableArray *)imageArray {
    _imageArray = imageArray;
    [self fillImagePosition];
}

- (void)setLinkArray:(NSMutableArray *)linkArray {
    _linkArray = linkArray;
}

- (void)fillImagePosition {
    if (self.imageArray.count == 0) {
        return;
    }
    // 获取行数
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    
    NSUInteger lineCount = [lines count];
    
    // 每行原点的数组
    CGPoint lineOrigins[lineCount];
    
    // 把ctFrame里每一行的初始坐标写到数组里
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    CTImageData *imgData = self.imageArray[0];
    
    // 遍历CTRun找出图片所在的CTRun并进行绘制
    for (int i = 0; i < lineCount; i++)
    {
        if(imgData.imgName == nil){
            break;
        }
        // 遍历每一行CTLine
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading; // 行距
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j = 0; j < CFArrayGetCount(runs); j++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j); // 获取当前的CTRun
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CTRunDelegateRef rundelegateRef = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            
            if (rundelegateRef == nil) {
                continue;
            }
            
            NSDictionary * metaDic = CTRunDelegateGetRefCon(rundelegateRef);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }

            // 遍历每一个CTRun
            CGRect runRect;
            CGFloat runAscent;
            CGFloat runDescent;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect.size.height = runDescent + runAscent;
            CGFloat xOffset =  CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runRect.origin.x = lineOrigins[i].x + xOffset;
            runRect.origin.y = lineOrigins[i].y;
            runRect.origin.y -= runDescent;
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            CGRect delegateRect = CGRectOffset(runRect, colRect.origin.x, colRect.origin.y);
            imgData.imagePosition = delegateRect;
            imgIndex ++;
            if (imgIndex == self.imageArray.count) {
                imgData = nil;
                break;
            }else {
                imgData = self.imageArray[imgIndex];
            }
        }
    }
}

- (void)dealloc
{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}



@end
