//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTData.h"
#import "CTFrameParserConfig.h"
#import "CTImageData.h"
#import "CTLinkData.h"

/** 用于生成绘制页面需要的CTFrameRef实例 */
@interface CTFrameParser : NSObject

/**
 *  @author jamal, 15-11-20 23:11:24
 *  @brief  根据配置文件来进行配置
 *  @param path   配置文件路径
 *  @param config 基本的配置
 *  @return 绘制最终需要的内容
 */
+ (CTData *)parserTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;

/**
*  @author jamal, 15-11-20 23:11:07
*
*  生成需要绘制的内容
*  @param content 绘制的内容
*  @param config  配置
*  @return 生成需要绘制的内容
*/
+ (CTData *)parserContentString:(NSString *)content config:(CTFrameParserConfig *)config;

@end
