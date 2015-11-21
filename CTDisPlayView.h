//
//  CTDisPlayView.h
//  CoreTextDemo
//
//  Created by jamalping on 15/11/20.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTData.h"
#import "CTFrameParser.h"
#import "CTUtil.h"

/**
 *  @author jamal, 15-11-20 23:11:17
 *
 *  @brief  绘制的容器
 */
@interface CTDisPlayView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)CTData *data; /**< 需要绘制的数据 */

@end
