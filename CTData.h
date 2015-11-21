//
//  CTData.h
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTImageData.h"
/**
 *  @author jamal, 15-11-20 23:11:01
 *
 *  @brief  用于保存由CTFrameParser生成的CTFrameRef实例，以及CTFrameRef绘制需要的高度
 */
@interface CTData : NSObject

@property (nonatomic,assign)CTFrameRef ctFrame; /**< CTFrameRef 实例 */
@property (nonatomic,assign)CGFloat height; /**< 绘制需要的高度 */
@property (nonatomic,strong)NSMutableArray *imageArray; /** 图片信息*/
@property (nonatomic,strong)NSMutableArray *linkArray; /** 链接信息*/

@end
