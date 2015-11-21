//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import "CTFrameParserConfig.h"

/** 用于配置绘制的参数 */
@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor blackColor];
    }
    return self;
}


@end
