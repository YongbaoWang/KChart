//
//  ColumnChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColumnChartModel.h"

@implementation ColumnChartModel

-(void)drawSerie:(Chart *)chart serie:(NSMutableDictionary *)serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);
	CGContextSetLineWidth(context, 1.0f);
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
    
	int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
	int            section        = [[serie objectForKey:@"section"] intValue];

	YAxis *yaxis = [[[chart.sections objectAtIndex:section] yAxises] objectAtIndex:yAxis];
	
	Section *sec = [chart.sections objectAtIndex:section];
	
    //设置选中点
    if(chart.enableSelection && chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        
        float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        float open  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:1] floatValue];
        float close = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:2] floatValue];
        float closeYesterday = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:3] floatValue];
        
        UIColor *color = kEverUpColor;
        if (close < open) {
            color = kEverDownColor;
        }else if(close > open){
            color = kEverUpColor;
        }else if(close == open){
            if (open > closeYesterday) {
                color = kEverUpColor;
            }else {
                color = kEverDownColor;
            }
        }
        
        CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);

        CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
        CGContextStrokePath(context);
        
        CGContextSetShouldAntialias(context, YES);
        CGContextBeginPath(context);
        CGContextSetFillColorWithColor(context, color.CGColor);
        if(!isnan([chart getLocalY:value withSection:section withAxis:yAxis])){
            CGContextAddArc(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, [chart getLocalY:value withSection:section withAxis:yAxis], 3, 0, 2*M_PI, 1);
        }
        CGContextFillPath(context);
    }
    
    //画柱状图
    CGContextSetLineWidth(context, 0.8);
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        
        float open  = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        float close = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float closeYesterday = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        
        float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
        float iy = [chart getLocalY:value withSection:section withAxis:yAxis];
        
        
        if(close < open){ //下跌
            if(i == chart.selectedIndex){
                CGContextSetStrokeColorWithColor(context, kEverDownColor.CGColor);
                CGContextSetFillColorWithColor(context, kEverDownColor.CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, kEverDownColor.CGColor);
                CGContextSetFillColorWithColor(context, kEverDownColor.CGColor);
            }
            CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iy, chart.plotWidth-2*chart.plotPadding,[chart getLocalY:yaxis.baseValue withSection:section withAxis:yAxis]-iy));

        }else if(close > open){ //上涨
            if(i == chart.selectedIndex){
                CGContextSetStrokeColorWithColor(context, kEverUpColor.CGColor);
                CGContextSetFillColorWithColor(context, kEverUpColor.CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, kEverUpColor.CGColor);
                CGContextSetFillColorWithColor(context, kEverUpColor.CGColor);
            }
            CGContextStrokeRect (context, CGRectMake (ix+chart.plotPadding, iy, chart.plotWidth-2*chart.plotPadding,[chart getLocalY:yaxis.baseValue withSection:section withAxis:yAxis]-iy));

        }else if(close == open){
            if (open > closeYesterday) {
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, kEverUpColor.CGColor);
                    CGContextSetFillColorWithColor(context, kEverUpColor.CGColor);
                }else{
                    CGContextSetStrokeColorWithColor(context, kEverUpColor.CGColor);
                    CGContextSetFillColorWithColor(context, kEverUpColor.CGColor);
                }
                CGContextStrokeRect (context, CGRectMake (ix+chart.plotPadding, iy, chart.plotWidth-2*chart.plotPadding,[chart getLocalY:yaxis.baseValue withSection:section withAxis:yAxis]-iy));

            }else {
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, kEverDownColor.CGColor);
                    CGContextSetFillColorWithColor(context, kEverDownColor.CGColor);
                }else{
                    CGContextSetStrokeColorWithColor(context, kEverDownColor.CGColor);
                    CGContextSetFillColorWithColor(context, kEverDownColor.CGColor);
                }
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iy, chart.plotWidth-2*chart.plotPadding,[chart getLocalY:yaxis.baseValue withSection:section withAxis:yAxis]-iy));

            }
        
        }
        
    }
    //标记X轴时间，只标记首尾
    NSString *fromDate = [[data objectAtIndex:chart.rangeFrom] objectAtIndex:4];
    NSString *toDate = [[data objectAtIndex:chart.rangeTo - 1] objectAtIndex:4];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    [fromDate drawInRect:CGRectMake(sec.frame.origin.x + sec.paddingLeft, sec.frame.origin.y + sec.frame.size.height + 2, 100, kYFontSize*2) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kYFontSize],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kYFontColor}];
    
    style.alignment = NSTextAlignmentRight;
    [toDate drawInRect:CGRectMake(sec.frame.origin.x + sec.frame.size.width - 100, sec.frame.origin.y + sec.frame.size.height + 2, 100, kYFontSize*2) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kYFontSize],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kYFontColor}];

}

-(void)setValuesForYAxis:(Chart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
		return;
	}
	
	NSMutableArray *data    = [serie objectForKey:@"data"];
	NSString       *yAxis   = [serie objectForKey:@"yAxis"];
	NSString       *section = [serie objectForKey:@"section"];
	
	YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
	if([serie objectForKey:@"decimal"] != nil){
		yaxis.decimal = [[serie objectForKey:@"decimal"] intValue];
	}
	
	float value = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:0] floatValue];
	if(!yaxis.isUsed){
        if (value != invalidData) {
            [yaxis setMax:value];
            [yaxis setMin:value];
        }
        yaxis.isUsed = YES;
    }
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        if(value > [yaxis max] && value != invalidData)
            [yaxis setMax:value];
        if(value < [yaxis min] && value != invalidData)
            [yaxis setMin:value];
    }

}

-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *lbl           = [serie objectForKey:@"label"];
//	int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
//	int            section        = [[serie objectForKey:@"section"] intValue];
	NSString       *color         = [serie objectForKey:@"labelColor"];
	
//	YAxis *yaxis = [[[chart.sections objectAtIndex:section] yAxises] objectAtIndex:yAxis];
//	NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
	
	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
//        NSString *fmt = [@"%@:" stringByAppendingFormat:@"%@",format];
//        [l appendFormat:fmt,lbl,value];
        [l appendFormat:@"%@:%@",lbl,[self roundVolumeDisplay:value]];
        [tmp setObject:l forKey:@"text"];
        
        NSMutableString *clr = [[NSMutableString alloc] init];
        [clr appendFormat:@"%f,",R];
        [clr appendFormat:@"%f,",G];
        [clr appendFormat:@"%f",B];
        [tmp setObject:clr forKey:@"color"];
        
        [label addObject:tmp];
    }
}

/**
 *  格式化float，显示单位，保留2位小数
 *
 *  @return 格式化后的字符串
 */
- (NSString *)roundVolumeDisplay:(CGFloat)value{
    
    NSString *unit = @"";
    if (value > 10000) {
        value /= 10000.0;
        unit = @"万";
    }
    if (value > 10000) {
        value /= 10000.0;
        unit = @"亿";
    }
    if (value > 10000) {
        value /= 10000.0;
        unit = @"万亿";
    }
    
    if ([unit isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%d",(int)value];
    }
    return [NSString stringWithFormat:@"%.2f%@",value,unit];
}

@end
