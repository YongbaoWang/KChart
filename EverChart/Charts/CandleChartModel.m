//
//  CandleChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CandleChartModel.h"

@implementation CandleChartModel

-(void)drawSerie:(Chart *)chart serie:(NSMutableDictionary *)serie{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES); //开启抗锯齿
    CGContextSetLineWidth(context, 1.0f);
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    int            section        = [[serie objectForKey:@"section"] intValue];
    
    Section *sec = [chart.sections objectAtIndex:section];
    
    float maxHigh = 0; //当前显示区域中：最高价中的最大值
    float minLow = MAXFLOAT; //当前显示区域中：最低价中的最小值
    int maxIndex = -1; //当前区域中，最大值出现在哪个坐标中
    int minIndex = -1; //当前区域中，最小值出现在哪个坐标中
    
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        float high  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        float open  = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        float close = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        
        if (maxHigh < high) {
            maxHigh = high;
            maxIndex = i;
        }
        if (minLow > low) {
            minLow = low;
            minIndex = i;
        }
        
        float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
        float iNx = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
        float iyo = [chart getLocalY:open withSection:section withAxis:yAxis];
        float iyc = [chart getLocalY:close withSection:section withAxis:yAxis];
        float iyh = [chart getLocalY:high withSection:section withAxis:yAxis];
        float iyl = [chart getLocalY:low withSection:section withAxis:yAxis];
        
        if(chart.enableSelection && i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
            
            //选中点：画竖线
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context,ix+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
            CGContextStrokePath(context);
            
            //画横线
            if (chart.touchY > sec.paddingTop && chart.touchY < sec.frame.size.height) {
                CGContextMoveToPoint(context, sec.frame.origin.x + sec.paddingLeft, chart.touchY);
                CGContextAddLineToPoint(context, sec.frame.origin.x + sec.frame.size.width, chart.touchY);
                CGContextStrokePath(context);
                
                //计算横线对应刻度
                YAxis *yaxis = sec.yAxises[0];
                CGFloat touchPointValue = (sec.frame.origin.y + sec.frame.size.height - chart.touchY)/(sec.frame.size.height - sec.paddingTop) * (yaxis.max - yaxis.min) + yaxis.min;

                //画横线左侧刻度标记
                NSString *text;
                if (yaxis.decimal == 0) {
                    text = [NSString stringWithFormat:@"%d",(int)touchPointValue];
                }else{
                    text = [NSString stringWithFormat:@"%.2f",touchPointValue];
                }
                
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentRight;
                
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kYFontSize],NSParagraphStyleAttributeName:style};
                CGSize textSize = [text sizeWithAttributes:attributes];
                CGRect rect = CGRectMake(sec.paddingLeft + sec.frame.origin.x - textSize.width - 2, chart.touchY - textSize.height/2.0, textSize.width + 1, textSize.height);
                
                CGContextSetShouldAntialias(context, YES);
                CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextSetLineWidth(context, 1);
                
                CGContextFillRect(context, rect);
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4];
                CGContextAddPath(context, path.CGPath);
                CGContextStrokePath(context);
                
                [text drawInRect:rect withAttributes:attributes];
                
            }
            
        }
        
        CGContextSetLineWidth(context, 0.8);
        //设置蜡烛图颜色
        if(close == open){
            UIColor *color = kEverUpColor;
            if (i > 0) {
                float closeYesterday = [[[data objectAtIndex:i-1] objectAtIndex:1] floatValue];
                if (open < closeYesterday) {
                    color = kEverDownColor;
                }
            }
            
            if(i == chart.selectedIndex){
                CGContextSetStrokeColorWithColor(context, color.CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, color.CGColor);
            }
        }else{
            if(open > close){ //下跌
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, kEverDownColor.CGColor);
                    CGContextSetFillColorWithColor(context, kEverDownColor.CGColor);
                }else{
                    CGContextSetStrokeColorWithColor(context, kEverDownColor.CGColor);
                    CGContextSetFillColorWithColor(context, kEverDownColor.CGColor);
                }
            }else{ //上涨
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, kEverUpColor.CGColor);
                }else{
                    CGContextSetStrokeColorWithColor(context, kEverUpColor.CGColor);
                }
            }
        }
        
        //画蜡烛图
        if(close == open){
            CGContextMoveToPoint(context, ix+chart.plotPadding, iyo);
            CGContextAddLineToPoint(context, iNx-chart.plotPadding,iyo);
            CGContextStrokePath(context);
            
        }else{
            if(open > close){ //下跌
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyo, chart.plotWidth-2*chart.plotPadding,iyc-iyo));
            }else{ //上涨
                CGContextStrokeRect(context, CGRectMake (ix+chart.plotPadding, iyc, chart.plotWidth-2*chart.plotPadding, iyo-iyc));
            }
        }
        
        //画烛芯
        if (close <= open) {
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, iyh);
            CGContextAddLineToPoint(context,ix+chart.plotWidth/2,iyl);
            CGContextStrokePath(context);
        }else { //烛芯 上下两部分 分开来画
            if (high > close) {
                CGContextMoveToPoint(context, ix + chart.plotWidth/2, iyh);
                CGContextAddLineToPoint(context, ix + chart.plotWidth/2, iyc);
                CGContextStrokePath(context);
            }
            if (low < open) {
                CGContextMoveToPoint(context, ix + chart.plotWidth/2, iyo);
                CGContextAddLineToPoint(context, ix + chart.plotWidth/2, iyl);
                CGContextStrokePath(context);

            }
            
        }
    }
    
    //画当前区域中，最大值、最小值  // →←
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:12]};

    if (maxIndex != -1) {
        float ix  = sec.frame.origin.x+sec.paddingLeft+(maxIndex-chart.rangeFrom)*chart.plotWidth;
        float iyh = [chart getLocalY:maxHigh withSection:section withAxis:yAxis];
        
        NSString *maxText;
        if (ix < sec.frame.size.width/2.0) {
            maxText = [NSString stringWithFormat:@"←%.2f",maxHigh];
            [maxText drawAtPoint:CGPointMake(ix + chart.plotWidth/2, iyh - 15) withAttributes:attributes];
        }else {
            maxText = [NSString stringWithFormat:@"%.2f→",maxHigh];
            CGSize textSize = [maxText sizeWithAttributes:attributes];
            [maxText drawAtPoint:CGPointMake(ix + chart.plotWidth/2 - textSize.width, iyh - 15) withAttributes:attributes];
        }
        
    }
    if (minIndex != -1) {
        float ix  = sec.frame.origin.x+sec.paddingLeft+(minIndex-chart.rangeFrom)*chart.plotWidth;
        float iyl = [chart getLocalY:minLow withSection:section withAxis:yAxis];

        NSString *minText ;
        if (ix < sec.frame.size.width /2.0) {
            minText = [NSString stringWithFormat:@"←%.2f",minLow];
            [minText drawAtPoint:CGPointMake(ix + chart.plotWidth/2, iyl) withAttributes:attributes];
        }else {
            minText = [NSString stringWithFormat:@"%.2f→",minLow];
            CGSize textSize = [minText sizeWithAttributes:attributes];
            [minText drawAtPoint:CGPointMake(ix + chart.plotWidth/2 - textSize.width, iyl) withAttributes:attributes];
        }
        
    }
}

-(void)setValuesForYAxis:(Chart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
		return;
	}
	
	NSMutableArray *data    = [serie objectForKey:@"data"];
	NSString       *yAxis   = [serie objectForKey:@"yAxis"];
	NSString       *section = [serie objectForKey:@"section"];
	
	YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
	
    float high = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:2] floatValue];
    float low = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:3] floatValue];
    
    if(!yaxis.isUsed){
        if (high != invalidData) {
            [yaxis setMax:high];
        }
        if (low != invalidData) {
            [yaxis setMin:low];
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
        
        float high = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        if(high > [yaxis max] && high != invalidData)
            [yaxis setMax:high];
        if(low < [yaxis min] && low != invalidData)
            [yaxis setMin:low];
    }
}

-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *color         = [serie objectForKey:@"color"];
	NSString       *negativeColor = [serie objectForKey:@"negativeColor"];
	
	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	float NR  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float NG  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float NB  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	
	float ZR  = 3/255.0;
	float ZG  = 3/255.0;
	float ZB  = 3/255.0;
	
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        float high  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:3] floatValue];
        float open  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        float close = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:1] floatValue];
        float preClose = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:6] floatValue];
        
        float inc  =  0;
        if (preClose > 0) {
            inc = (close-preClose)*100/preClose; //涨跌幅
            
        }
        
        float closeYesterday = 0;
        if (chart.selectedIndex - 1 >= 0) {
             closeYesterday = [[[data objectAtIndex:chart.selectedIndex - 1] objectAtIndex:1] floatValue];
        }
        
        //收盘价
        NSString *value = [NSString stringWithFormat:@"%.2f",close];
        NSMutableString *clr = [[NSMutableString alloc] init];
        if(close>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if (close < open) {
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            if (open > closeYesterday) {
                [clr appendFormat:@"%f,",R];
                [clr appendFormat:@"%f,",G];
                [clr appendFormat:@"%f",B];
            }else {
                [clr appendFormat:@"%f,",NR];
                [clr appendFormat:@"%f,",NG];
                [clr appendFormat:@"%f",NB];
            }
        }
        [label addObject:@{@"text":value,@"color":clr}];
        
        //涨跌幅
        if (preClose > 0) {
            value = [NSString stringWithFormat:@"%+.2f%%",inc];
            
            clr = [[NSMutableString alloc] init];
            if(inc > 0){
                [clr appendFormat:@"%f,",R];
                [clr appendFormat:@"%f,",G];
                [clr appendFormat:@"%f",B];
            }else if(inc < 0){
                [clr appendFormat:@"%f,",NR];
                [clr appendFormat:@"%f,",NG];
                [clr appendFormat:@"%f",NB];
            }else{
                [clr appendFormat:@"%f,",ZR];
                [clr appendFormat:@"%f,",ZG];
                [clr appendFormat:@"%f",ZB];
            }
            [label addObject:@{@"text":value,@"color":clr}];

        }

        //最高价
        [label addObject:@{@"text":@"高",@"color":@"0,0,0"}];
        value = [NSString stringWithFormat:@"%.2f",high];
        
        clr = [[NSMutableString alloc] init];
        if(high > closeYesterday){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(high < closeYesterday){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [label addObject:@{@"text":value,@"color":clr}];

        
        //最低价
        [label addObject:@{@"text":@"低",@"color":@"0,0,0"}];
        value = [NSString stringWithFormat:@"%.2f",low];
        
        clr = [[NSMutableString alloc] init];
        if(low > closeYesterday){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(low < closeYesterday){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [label addObject:@{@"text":value,@"color":clr}];
        
        //开盘价
        [label addObject:@{@"text":@"开",@"color":@"0,0,0"}];
        value = [NSString stringWithFormat:@"%.2f",open];

        clr = [[NSMutableString alloc] init];
        if(open> closeYesterday){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(open < closeYesterday){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [label addObject:@{@"text":value,@"color":clr}];
        
    }

}

-(void)drawTips:(Chart *)chart serie:(NSMutableDictionary *)serie{
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 1.0f);
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *type          = [serie objectForKey:@"type"];
	NSString       *name          = [serie objectForKey:@"name"];
	int            section        = [[serie objectForKey:@"section"] intValue];
	NSMutableArray *category      = [serie objectForKey:@"category"];
	Section *sec = [chart.sections objectAtIndex:section];
	
	if([type isEqualToString:@"candle"] && chart.enableSelection){
		for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
			
			float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
				
//                float open  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
                float close = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:1] floatValue];
                float preClose = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:6] floatValue];

                float inc  =  0;
                if (preClose > 0) {
                    inc = (close-preClose)*100/preClose; //涨跌幅

                }
                UIColor *incColor = (inc > 0 ? kEverUpColor : kEverDownColor);
                
                NSString *tipsText = [NSString stringWithFormat:@"%@ 涨: ",[category objectAtIndex:chart.selectedIndex]];
                NSString *tipsValue = [NSString stringWithFormat:@"%.2f%%",inc];
                if (preClose == 0) {
                    tipsValue = @"--";
                }
                
				CGContextSetShouldAntialias(context, YES);
                CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                
                CGSize size = [[tipsText stringByAppendingString:tipsValue] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}];
                CGSize textSize = [tipsText sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}];
				
				int x = ix+chart.plotWidth/2;
				int y = sec.frame.origin.y+sec.paddingTop;
				if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
					x= x-(size.width+4);
				}
				CGContextFillRect (context, CGRectMake (x, y, size.width+4,size.height+2));
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, size.width+4,size.height+2) cornerRadius:4];
                CGContextAddPath(context, path.CGPath);
                CGContextStrokePath(context);
                
                [tipsText drawAtPoint:CGPointMake(x+2,y+1) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}];
                [tipsValue drawAtPoint:CGPointMake(x + 2 + textSize.width, y + 1) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0],NSForegroundColorAttributeName:incColor}];
				CGContextSetShouldAntialias(context, NO);
                
                
			}
		}
	}
	
	if([type isEqualToString:@"line"] && [name isEqualToString:@"price"]){
		for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
			
			float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
				
				CGContextSetShouldAntialias(context, YES);
				CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 0.8); 
                CGSize size = [[category objectAtIndex:chart.selectedIndex] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}];
				
				int x = ix+chart.plotWidth/2;
				int y = sec.frame.origin.y+sec.paddingTop;
				if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
					x = x-(size.width+4);
				}
				CGContextFillRect (context, CGRectMake (x, y, size.width+4,size.height+2)); 
				CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0); 
                [[category objectAtIndex:chart.selectedIndex] drawAtPoint:CGPointMake(x+2,y+1) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]}];
				CGContextSetShouldAntialias(context, NO);	
			}
		}
	}
	
}

@end
