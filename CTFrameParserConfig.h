//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @author jamal, 15-11-20 23:11:34
 *
 *  @brief  参数配置类
 */
@interface CTFrameParserConfig : NSObject

@property (nonatomic,assign)CGFloat width; /**< 宽度 */
@property (nonatomic,assign)CGFloat fontSize; /**< 字体大小 */
@property (nonatomic,assign)CGFloat lineSpace; /**< 行距 */
@property (nonatomic,strong)UIColor *textColor; /**< 文字颜色 */

@end
