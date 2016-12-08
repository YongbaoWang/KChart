//
//  MACDChartModel.m
//  TestChart
//
//  Created by Ever on 15/12/17.
//  Copyright © 2015年 Lucky. All rights reserved.
//

#import "MACDChartModel.h"

@implementation MACDChartModel

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
    NSString       *color         = [serie objectForKey:@"color"];
    
    float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    
    Section *sec = [chart.sections objectAtIndex:section];
    
    //设置选中点 竖线以及小球颜色
    if(chart.enableSelection && chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        
        //设置选中点竖线
        float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        if (section > 0) {
            CGContextSetShouldAntialias(context, YES);
            CGContextSetLineWidth(context, 0.8);
            CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
            CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
            CGContextStrokePath(context);
            
        }
        
        //设置选中点小球颜色
        CGContextBeginPath(context);
        CGContextSetRGBFillColor(context, R, G, B, 1.0);
        if(!isnan([chart getLocalY:value withSection:section withAxis:yAxis])){
            CGContextAddArc(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, [chart getLocalY:value withSection:section withAxis:yAxis], 3, 0, 2*M_PI, 1);
        }
        CGContextFillPath(context);
    }
    
    CGContextSetShouldAntialias(context, YES);
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count-1){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        if (i<chart.rangeTo-1 && [data objectAtIndex:(i+1)] != nil) {
            float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
            float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
            float iNx  = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
            float iy = [chart getLocalY:value withSection:section withAxis:yAxis];
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
            
            float y = [chart getLocalY:([[[data objectAtIndex:(i+1)] objectAtIndex:0] floatValue]) withSection:section withAxis:yAxis];
            if(!isnan(y)){
                CGContextAddLineToPoint(context, iNx+chart.plotWidth/2, y);
            }
            
            CGContextStrokePath(context);
        }
    }
    

    //标记X轴时间，只标记首尾
    NSString *fromDate = [[data objectAtIndex:chart.rangeFrom] objectAtIndex:1];
    NSString *toDate = [[data objectAtIndex:chart.rangeTo - 1] objectAtIndex:1];
    
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
        [yaxis setMax:value];
        [yaxis setMin:value];
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
        if(value > [yaxis max])
            [yaxis setMax:value];
        if(value < [yaxis min])
            [yaxis setMin:value];
    }
}

-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    //	NSString       *type          = [serie objectForKey:@"type"];
    NSString       *lbl           = [serie objectForKey:@"label"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    int            section        = [[serie objectForKey:@"section"] intValue];
    NSString       *color         = [serie objectForKey:@"color"];
    
    YAxis *yaxis = [[[chart.sections objectAtIndex:section] yAxises] objectAtIndex:yAxis];
    NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
    
    float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        NSString *fmt = [@"%@:" stringByAppendingFormat:@"%@",format];
        [l appendFormat:fmt,lbl,value];
        [tmp setObject:l forKey:@"text"];
        
        NSMutableString *clr = [[NSMutableString alloc] init];
        [clr appendFormat:@"%f,",R];
        [clr appendFormat:@"%f,",G];
        [clr appendFormat:@"%f",B];
        [tmp setObject:clr forKey:@"color"];
        
        [label addObject:tmp];
    }	    
}

@end
