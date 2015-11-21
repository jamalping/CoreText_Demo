//
//  CTImageData.h
//  CoreTextDemo
//
//  Created by jamalping on 15/11/21.
//  Copyright © 2015年 cisc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @author jamal, 15-11-21 16:11:56
 *
 *  @brief  存储图片数据
 */
@interface CTImageData : NSObject

@property (nonatomic,copy)NSString *imgName; /** 图片名*/
@property (nonatomic,assign)NSUInteger point; /** 开始坐标*/
@property (nonatomic,assign)CGRect imagePosition; /** 开始坐标*/

@end
