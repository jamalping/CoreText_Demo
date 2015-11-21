//
//  CTDisPlayView.m
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import "CTDisPlayView.h"
#import "SDWebImageManager.h"
#import "CTImageData.h"

@implementation CTDisPlayView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (void)setupEvents {
    UIGestureRecognizer * tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(userTapGestureDetected:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    for (CTImageData * imageData in self.data.imageArray) {
        // 翻转坐标系，因为 imageData 中的坐标是 CoreText 的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y
        - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击位置 Point 是否在 rect 之内
        if (CGRectContainsPoint(rect, point)) {
            // 在这里处理点击后的逻辑
            NSLog(@"bingo");
            break;
        }
    }
    CTLinkData *linkData = [CTUtil touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSLog(@"hint link!");
        return;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"转换前的坐标系%@",NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    // 2、  ad缩放bc旋转tx,ty位移，基础的2D矩阵
    //    x=ax+cy+tx
    //    y=bx+dy+ty
    CGContextConcatCTM(context, CGAffineTransformMake(1.0, 0, 0, -1.0, 0, self.frame.size.height));
    
    //    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //    CGContextScaleCTM(context, 1.0, -1.0);   // 将坐标系缩放，X坐标不变，Y坐标方向相反（矢量变换）
    NSLog(@"转换后的坐标系%@",NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
        for (int i = 0; i < self.data.imageArray.count; i++) {
             CTImageData *imgData = self.data.imageArray[i];
            CGContextDrawImage(context, imgData.imagePosition, [UIImage imageNamed:imgData.imgName].CGImage);
        }
    }
}
@end
