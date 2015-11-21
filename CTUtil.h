//
//  CTUtil.h
//  CoreTextDemo
//
//  Created by jamalping on 15/11/21.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTLinkData.h"
#import <UIKit/UIKit.h>
#import "CTData.h"
@interface CTUtil : NSObject

/**
 *  @author jamal, 15-11-21 18:11:19
 *
 *  @brief  监测点击是否在链接上
 *  @param view  点击的view
 *  @param point 点击的点
 *  @param data  CTData
 *  @return 链接数据
 */
+ (CTLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CTData *)data;

@end
