//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser
/**
 *  @author jamal, 15-11-20 23:11:24
 *  @brief  根据配置文件来进行配置
 *  @param path   配置文件路径
 *  @param config 基本的配置
 *  @return 绘制最终需要的内容
 */
+ (CTData *)parserTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config {
    NSMutableArray *imgAry = [NSMutableArray array];
    NSMutableArray *linkAry = [NSMutableArray array];
    
    NSAttributedString *content = [self loadTemplateFile:path config:config imageAry:imgAry linkAry:linkAry];
    CTData *data = [self parserContentAttributeString:content config:config];
    data.imageArray = imgAry;
    data.linkArray = linkAry;
    return data;
}

/**
 *  @author jamal, 15-11-20 23:11:44
 *  @brief  读取配置文件，并根据配置文件进行排版
 *  @param path   配置文件路径
 *  @param config 基本的配置
 *  @return 配置好的NSAttributedString实例
 */
+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config imageAry:(NSMutableArray *)imageAry linkAry:(NSMutableArray *)linkAry {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in array) {
                NSString *type = dic[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parserAttributedContentFromNSDictionary:dic config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]) {
                    CTImageData *imgData = [[CTImageData alloc] init];
                    imgData.imgName = dic[@"name"];
                    imgData.point = [result length];
                    [imageAry addObject:imgData];
                    NSAttributedString *as = [self parseImageDataWithDictionary:dic config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"link"]) {
                    NSUInteger startPos = result.length;
                    
                    NSAttributedString *as =
                    [self parserAttributedContentFromNSDictionary:dic
                                                          config:config];
                    [result appendAttributedString:as];
                    // 创建 CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    CTLinkData *linkData = [[CTLinkData alloc] init];
                    linkData.title = dic[@"content"];
                    linkData.url = dic[@"url"];
                    linkData.range = linkRange;
                    [linkAry addObject:linkData];
                }
            }
        }
    }
    return result;
}

/**
 *  @author jamal, 15-11-20 23:11:27
 *
 *  @brief  生成排版好的 NSAttributedString实例
 *  @param dic    配置参数的字典
 *  @param config 基本配置
 *  @return 生成排版好的 NSAttributedString实例
 */
+ (NSAttributedString *)parserAttributedContentFromNSDictionary:(NSDictionary *)dic config:(CTFrameParserConfig *)config {
    NSMutableDictionary *dict = [self attributerWithConfig:config];
    // setColor
    UIColor *color = [self parserColor:dic[@"color"]];
    if (color) {
        dict[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // setFont
    CGFloat fontSize = [dic[@"size"] floatValue];
    if (fontSize>0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dic[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:dict];
    
}

+ (NSAttributedString *)parseImageDataWithDictionary:(NSDictionary *)dic config:(CTFrameParserConfig *)config {
    CTRunDelegateCallbacks imageCallBacks;
    imageCallBacks.version = kCTRunDelegateCurrentVersion;
    imageCallBacks.dealloc = RunDelegateDeallocCallback;
    imageCallBacks.getAscent = RunDelegateGetAscentCallback;
    imageCallBacks.getDescent = RunDelegateGetDescentCallback;
    imageCallBacks.getWidth = RunDelegateGetWidthCallback;

    CTRunDelegateRef rundelegateRef = CTRunDelegateCreate(&imageCallBacks, (__bridge void*) dic);
    // 使用 0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributeDic = [self attributerWithConfig:config];
    
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributeDic
                                        ];
    [space addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)rundelegateRef range:NSMakeRange(0, 1)];
    CFRelease(rundelegateRef);
    return space;
}

/**
 *  @author jamal, 15-11-20 23:11:02
 *
 *  @brief  颜色的解析
 *  @param colorString 颜色的字符串
 *  @return Color
 */
+ (UIColor *)parserColor:(NSString *)colorString {
    UIColor *color;
    if ([colorString containsString:@"red"]) {
        color = [UIColor redColor];
    }else if ([colorString containsString:@"black"]) {
        color = [UIColor blackColor];
    }else if ([colorString containsString:@"blue"]) {
        color = [UIColor blueColor];
    }else if ([colorString containsString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    return color;
}


/**
 *  @author jamal, 15-11-20 23:11:56
 *
 *  @brief  生成绘制最终需要的数据
 *  @param content 绘制的内容
 *  @param config  基本配置
 *  @return 最终绘制需要的数据
 */
+ (CTData *)parserContentAttributeString:(NSAttributedString *)content config:(CTFrameParserConfig *)config {
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    CTFrameRef frameRef = [self creatFrameWithFramesetter:framesetterRef config:config height:textHeight];
    CTData *data = [[CTData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    return data;
}

/**
 *  @author jamal, 15-11-20 23:11:56
 *
 *  @brief  生成绘制最终需要的数据
 *  @param content 绘制的内容
 *  @param config  基本配置
 *  @return 最终绘制需要的数据
 */
+ (CTData *)parserContentString:(NSString *)content config:(CTFrameParserConfig *)config {
    NSDictionary *attributeDic = [self attributerWithConfig:config];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:content attributes:attributeDic];
    // 创建CTFrameSetterRef实例
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeString);
    
    // 获取要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    CTFrameRef frameRef = [self creatFrameWithFramesetter:frameSetterRef config:config height:textHeight];
    
    // 将生成好的 CTFrameRef 实例和计算好的绘制高度保存到CTData 实例中，最后返回CTData实例
    CTData *data = [[CTData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    
    CFRelease(frameRef);
    CFRelease(frameSetterRef);
    return data;
}

/**
 *  @author jamal, 15-11-20 23:11:34
 *
 *  @brief  将配置转化成可直接使用的配置
 *  @param config 基本配置
 *  @return 将配置转化成可直接使用的配置
 */
+ (NSMutableDictionary *)attributerWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    const CFIndex KNumberOfSettings = 3;
    
    CTParagraphStyleSetting setting[KNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpace},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpace},
    };
    
    CTParagraphStyleRef theParagrapRef = CTParagraphStyleCreate(setting, KNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dic[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dic[(id)NSParagraphStyleAttributeName] = (__bridge id)(theParagrapRef);
    
    CFRelease(fontRef);
    CFRelease(theParagrapRef);
    return dic;
}

/**
 *  @author jamal, 15-11-20 23:11:07
 *
 *  @brief  根据配置生成CTFrameRef实例
 *  @param framesetterRef framesetterRef
 *  @param config         基本配置
 *  @param height         绘制的内容高度
 *  @return CTFrameRef实例
 */
+ (CTFrameRef)creatFrameWithFramesetter:(CTFramesetterRef)framesetterRef
                           config:(CTFrameParserConfig *)config
                           height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

void RunDelegateDeallocCallback (void *refCon) {
    NSLog(@"RunDelegate dealloc");
}

CGFloat RunDelegateGetAscentCallback(void *refCon)
{
    return [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:@"height"] floatValue];
}

CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    return 0;
}


CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    return [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:@"width"] floatValue];
}

@end
