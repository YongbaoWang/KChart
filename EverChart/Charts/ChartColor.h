//
//  ChartColor.h
//  TestChart
//
//  Created by Ever on 15/12/15.
//  Copyright © 2015年 Lucky. All rights reserved.
//

#ifndef ChartColor_h
#define ChartColor_h

#define invalidData (-1000000) //当为此数据时，在坐标轴上不显示

#define kBtnBgColor [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1] //btn 背景色

//k 线图
#define kEverUpColor [UIColor colorWithRed:252/255.0 green:2/255.0 blue:42/255.0 alpha:1] //上涨颜色
#define kEverDownColor [UIColor colorWithRed:38/255.0 green:167/255.0 blue:38/255.0 alpha:1] //下跌颜色
#define kBorderColor [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1] //边框颜色
#define kDashColor [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1] //虚线颜色
#define kYFontColor [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] //Y轴刻度文字颜色

#define kYFontSize (14) //Y轴刻度文字大小
#define KYFontName @"Helvetica" //Y轴刻度文字字体

//分时图
#define kFenShiUpColor [UIColor colorWithRed:252/255.0 green:15/255.0 blue:29/255.0 alpha:1] //成交量上涨颜色
#define kFenShiDownColor [UIColor colorWithRed:22/255.0 green:151/255.0 blue:25/255.0 alpha:1] //成交量下跌颜色
#define kFenShiEqualColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] //成交量持平颜色
#define kYFontSizeFenShi (10) //Y轴刻度文字大小 分时图中
#define kFenShiVolumeYFontColor [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1] //分时成交量图：Y轴刻度文字颜色


#endif /* ChartColor_h */
