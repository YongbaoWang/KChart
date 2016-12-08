//
//  ViewController.h
//  EverChart
//
//  Created by 永宝 on 16/3/28.
//  Copyright © 2016年 Beijing Byecity International Travel CO., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chart.h"

@interface ViewController : UIViewController

/**
 *  k线图
 */
@property (nonatomic,strong) Chart *candleChart;

@end

