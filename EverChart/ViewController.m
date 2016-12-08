//
//  ViewController.m
//  EverChart
//
//  Created by 永宝 on 16/3/28.
//  Copyright © 2016年 Beijing Byecity International Travel CO., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "UtilsMacro.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupChart]; //初始化K线图
    
    [self loadData]; //请求K线图数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - 请求数据
- (void)loadData{
    
    //注意：txt 文件中的ma 值没有使用； k线图中的ma，是根据收盘价、开盘价等用代码计算得出的；
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [self requestFinished:dataArray];
}

#pragma mark - Chart Action
- (void)setupChart{
    
    //candleChart
    self.candleChart = [[Chart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_MAX_LENGTH, SCREEN_MIN_LENGTH)];
    [self.view addSubview:self.candleChart];
    self.candleChart.enableSelection = YES;
    
    //init chart
    [self initKChart];
    
}

#pragma mark - KChart Action
-(void)initKChart{
    
    //参数比较多，慢慢看
    NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"0",@"5",@"20",@"5",nil];
    [self.candleChart setPadding:padding];
    NSMutableArray *secs = [[NSMutableArray alloc] init];
    [secs addObject:@"2"]; //设置上下两部分比例
    [secs addObject:@"1"];
    
    [self.candleChart addSections:2 withRatios:secs];
    [[[self.candleChart sections] objectAtIndex:0] addYAxis:0];
    
    [[[self.candleChart sections] objectAtIndex:1] addYAxis:0];
    
    [self.candleChart getYAxis:0 withIndex:0].ext = 0.2; //控制上下展开幅度
    [self.candleChart getYAxis:0 withIndex:0].tickInterval = 4; //虚线数量
    [self.candleChart getYAxis:1 withIndex:0].tickInterval = 2;
    [[[self.candleChart sections] objectAtIndex:0] setPaddingTop:45];//设置蜡烛图上部间距
    CGFloat left = 40;
    [[[self.candleChart sections] objectAtIndex:0] setPaddingLeft:left];
    [[[self.candleChart sections] objectAtIndex:1] setPaddingLeft:left];
    
    
    NSMutableArray *series = [[NSMutableArray alloc] init];
    
    NSMutableArray *secOne = [[NSMutableArray alloc] init];
    NSMutableArray *secTwo = [[NSMutableArray alloc] init];
    
    //price
    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [serie setObject:@"price" forKey:@"name"];
    [serie setObject:@"Price" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"candle" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"252,2,42" forKey:@"color"];
    [serie setObject:@"38,167,38" forKey:@"negativeColor"];
    [serie setObject:@"198,13,22" forKey:@"selectedColor"];
    [serie setObject:@"13,103,15" forKey:@"negativeSelectedColor"];
    [serie setObject:@"252,2,42" forKey:@"labelColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA5
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma5" forKey:@"name"];
    [serie setObject:@"MA5" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"80,80,80" forKey:@"color"];
    [serie setObject:@"80,80,80" forKey:@"negativeColor"];
    [serie setObject:@"80,80,80" forKey:@"selectedColor"];
    [serie setObject:@"80,80,80" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA10
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma10" forKey:@"name"];
    [serie setObject:@"10" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"152,38,251" forKey:@"color"];
    [serie setObject:@"152,38,251" forKey:@"negativeColor"];
    [serie setObject:@"152,38,251" forKey:@"selectedColor"];
    [serie setObject:@"152,38,251" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA20
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma20" forKey:@"name"];
    [serie setObject:@"20" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"252,175,45" forKey:@"color"];
    [serie setObject:@"252,175,45" forKey:@"negativeColor"];
    [serie setObject:@"252,175,45" forKey:@"selectedColor"];
    [serie setObject:@"252,175,45" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA30
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma30" forKey:@"name"];
    [serie setObject:@"30" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"10,20,145" forKey:@"color"];
    [serie setObject:@"10,20,145" forKey:@"negativeColor"];
    [serie setObject:@"10,20,145" forKey:@"selectedColor"];
    [serie setObject:@"10,20,145" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //VOL
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"vol" forKey:@"name"];
    [serie setObject:@"总手" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"column" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:@"0" forKey:@"decimal"];
    [serie setObject:@"176,52,52" forKey:@"color"];
    [serie setObject:@"77,143,42" forKey:@"negativeColor"];
    [serie setObject:@"176,52,52" forKey:@"selectedColor"];
    [serie setObject:@"77,143,42" forKey:@"negativeSelectedColor"];
    [serie setObject:@"80,80,80" forKey:@"labelColor"];
    [series addObject:serie];
    [secTwo addObject:serie];
    
    //candleChart init
    [self.candleChart setSeries:series];
    
    [[[self.candleChart sections] objectAtIndex:0] setSeries:secOne];
    [[[self.candleChart sections] objectAtIndex:1] setSeries:secTwo];
    [[[self.candleChart sections] objectAtIndex:1] setPaging:YES];
    
    
    NSString *indicatorsString =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"indicators" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    if(indicatorsString != nil){
        NSData *data = [indicatorsString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *indicators = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for(NSObject *indicator in indicators){
            if([indicator isKindOfClass:[NSArray class]]){
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for(NSDictionary *indic in (NSArray *)indicator){
                    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
                    [self setOptions:indic ForSerie:serie];
                    [arr addObject:serie];
                }
                [self.candleChart addSerie:arr];
            }else{
                NSDictionary *indic = (NSDictionary *)indicator;
                NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
                [self setOptions:indic ForSerie:serie];
                [self.candleChart addSerie:serie];
            }
        }
    }
    
}

- (void)requestFinished:(NSArray *)responseObject{
    
    [self.candleChart reset];
    [self.candleChart clearData];
    [self.candleChart clearCategory];
    
    if (responseObject == nil  || responseObject.count == 0) {
        NSLog(@"K线图数据源数组为空");
        return;
    }
    
    NSMutableArray *data =[[NSMutableArray alloc] init];
    NSMutableArray *category =[[NSMutableArray alloc] init];
    
    for(int i = (int)responseObject.count - 1;i >= 0;i--){
        
        NSDictionary *dic = responseObject[i];
        [category addObject:dic[@"dateTime"]];
        
        NSString *preClose = @"0";
        if (i + 1 < responseObject.count) {
            preClose = [responseObject[i+1] valueForKey:@"closePri"];
        }
        
        //开盘价、收盘价、最高价、最低价、成交量、时间
        NSArray *item = @[dic[@"openPri"],dic[@"closePri"],dic[@"todayMax"],dic[@"todayMin"],dic[@"traNumber"],dic[@"dateTime"],preClose];
        
        [data addObject:item]; //根据实际需要，自己传递数据
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [self generateData:dic From:data];
    [self setData:dic];
    
    NSMutableArray *cate = [[NSMutableArray alloc] init];
    for(int i = 0;i < category.count; i++){
        [cate addObject:[category objectAtIndex:i]];
    }
    [self setCategory:cate];
    
    [self.candleChart setNeedsDisplay];
}

#pragma mark - Chart Common Action
-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie;{
    [serie setObject:[options objectForKey:@"name"] forKey:@"name"];
    [serie setObject:[options objectForKey:@"label"] forKey:@"label"];
    [serie setObject:[options objectForKey:@"type"] forKey:@"type"];
    [serie setObject:[options objectForKey:@"yAxis"] forKey:@"yAxis"];
    [serie setObject:[options objectForKey:@"section"] forKey:@"section"];
    [serie setObject:[options objectForKey:@"color"] forKey:@"color"];
    [serie setObject:[options objectForKey:@"negativeColor"] forKey:@"negativeColor"];
    [serie setObject:[options objectForKey:@"selectedColor"] forKey:@"selectedColor"];
    [serie setObject:[options objectForKey:@"negativeSelectedColor"] forKey:@"negativeSelectedColor"];
}

-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data{
    
    //price
    NSMutableArray *price = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        [price addObject: [data objectAtIndex:i]];
    }
    [dic setObject:price forKey:@"price"];
    
    //VOL
    NSMutableArray *vol = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",[[[data objectAtIndex:i] objectAtIndex:4] floatValue]/100]]; //成交量
        [item addObject:[[data objectAtIndex:i] objectAtIndex:0]]; //今天开盘价
        [item addObject:[[data objectAtIndex:i] objectAtIndex:1]]; //今天收盘价
        if (i > 0) {
            [item addObject:[[data objectAtIndex:i-1] objectAtIndex:1]]; //昨天收盘价
        }else{
            [item addObject:@"0"];
        }
        [item addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        
        [vol addObject:item];
    }
    [dic setObject:vol forKey:@"vol"];
    
    //MA 5
    NSMutableArray *ma5 = [[NSMutableArray alloc] init];
    for (int i = 0; i<5; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [ma5 addObject:item];
        
    }
    for(int i = 5;i < data.count;i++){
        float val = 0;
        for(int j=i;j>i-5;j--){
            val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
        }
        val = val/5;
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma5 addObject:item];
    }
    [dic setObject:ma5 forKey:@"ma5"];
    
    //MA 10
    NSMutableArray *ma10 = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [ma10 addObject:item];
        
    }
    for(int i = 10;i < data.count;i++){
        float val = 0;
        for(int j=i;j>i-10;j--){
            val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
        }
        val = val/10;
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma10 addObject:item];
    }
    [dic setObject:ma10 forKey:@"ma10"];
    
    //MA 20
    NSMutableArray *ma20 = [[NSMutableArray alloc] init];
    for (int i = 0; i<20; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [ma20 addObject:item];
        
    }
    for(int i = 20;i < data.count;i++){
        float val = 0;
        for(int j=i;j>i-20;j--){
            val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
        }
        val = val/20;
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma20 addObject:item];
    }
    [dic setObject:ma20 forKey:@"ma20"];
    
    //MA 30
    NSMutableArray *ma30 = [[NSMutableArray alloc] init];
    for (int i = 0; i<30; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [ma30 addObject:item];
        
    }
    
    for(int i = 30;i < data.count;i++){
        float val = 0;
        for(int j=i;j>i-30;j--){
            val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
        }
        val = val/30;
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma30 addObject:item];
    }
    [dic setObject:ma30 forKey:@"ma30"];
    
    //RSI6
    NSMutableArray *rsi6 = [[NSMutableArray alloc] init];
    for (int i = 0; i<6; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [item addObject:@"0000-00-00"];
        [rsi6 addObject:item];
        
    }
    
    for(int i = 6;i < data.count;i++){
        float incVal  = 0;
        float decVal = 0;
        float rs = 0;
        for(int j=i;j>i-6;j--){
            float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
            if(interval >= 0){
                incVal += interval;
            }else{
                decVal -= interval;
            }
        }
        
        rs = incVal/decVal;
        float rsi =100-100/(1+rs);
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
        [item addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [rsi6 addObject:item];
        
    }
    [dic setObject:rsi6 forKey:@"rsi6"];
    
    //RSI12
    NSMutableArray *rsi12 = [[NSMutableArray alloc] init];
    for (int i = 0; i<12; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [item addObject:@"0000-00-00"];
        [rsi12 addObject:item];
        
    }
    
    for(int i = 12;i < data.count;i++){
        float incVal  = 0;
        float decVal = 0;
        float rs = 0;
        for(int j=i;j>i-12;j--){
            float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
            if(interval >= 0){
                incVal += interval;
            }else{
                decVal -= interval;
            }
        }
        
        rs = incVal/decVal;
        float rsi =100-100/(1+rs);
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
        [item addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [rsi12 addObject:item];
    }
    [dic setObject:rsi12 forKey:@"rsi12"];
    
    //RSI24
    NSMutableArray *rsi24 = [[NSMutableArray alloc] init];
    for (int i = 0; i<24; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [item addObject:@"0000-00-00"];
        [rsi24 addObject:item];
        
    }
    
    for(int i = 24;i < data.count;i++){
        float incVal  = 0;
        float decVal = 0;
        float rs = 0;
        for(int j=i;j>i-24;j--){
            float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
            if(interval >= 0){
                incVal += interval;
            }else{
                decVal -= interval;
            }
        }
        
        rs = incVal/decVal;
        float rsi =100-100/(1+rs);
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
        [item addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [rsi24 addObject:item];
    }
    [dic setObject:rsi24 forKey:@"rsi24"];
    
    
    //WR
    NSMutableArray *wr = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [item addObject:@"0000-00-00"];
        [wr addObject:item];
        
    }
    
    for(int i = 10;i < data.count;i++){
        float h  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float l = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        float c = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        for(int j=i;j>i-10;j--){
            if([[[data objectAtIndex:j] objectAtIndex:2] floatValue] > h){
                h = [[[data objectAtIndex:j] objectAtIndex:2] floatValue];
            }
            
            if([[[data objectAtIndex:j] objectAtIndex:3] floatValue] < l){
                l = [[[data objectAtIndex:j] objectAtIndex:3] floatValue];
            }
        }
        
        float val = (h-c)/(h-l)*100;
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [item addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [wr addObject:item];
    }
    [dic setObject:wr forKey:@"wr"];
    
    //KDJ
    NSMutableArray *kdj_k = [[NSMutableArray alloc] init];
    NSMutableArray *kdj_d = [[NSMutableArray alloc] init];
    NSMutableArray *kdj_j = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<10; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [item addObject:@"0000-00-00"];
        [kdj_k addObject:item];
        [kdj_d addObject:item];
        [kdj_j addObject:item];
        
    }
    
    float prev_k = 50;
    float prev_d = 50;
    float rsv = 0;
    for(int i = 10;i < data.count;i++){
        float h  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float l = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        float c = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        for(int j=i;j>i-10;j--){
            if([[[data objectAtIndex:j] objectAtIndex:2] floatValue] > h){
                h = [[[data objectAtIndex:j] objectAtIndex:2] floatValue];
            }
            
            if([[[data objectAtIndex:j] objectAtIndex:3] floatValue] < l){
                l = [[[data objectAtIndex:j] objectAtIndex:3] floatValue];
            }
        }
        
        if(h!=l)
            rsv = (c-l)/(h-l)*100;
        float k = 2*prev_k/3+1*rsv/3;
        float d = 2*prev_d/3+1*k/3;
        float j = d+2*(d-k);
        
        prev_k = k;
        prev_d = d;
        
        NSMutableArray *itemK = [[NSMutableArray alloc] init];
        [itemK addObject:[@"" stringByAppendingFormat:@"%f",k]];
        [itemK addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [kdj_k addObject:itemK];
        NSMutableArray *itemD = [[NSMutableArray alloc] init];
        [itemD addObject:[@"" stringByAppendingFormat:@"%f",d]];
        [itemD addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [kdj_d addObject:itemD];
        NSMutableArray *itemJ = [[NSMutableArray alloc] init];
        [itemJ addObject:[@"" stringByAppendingFormat:@"%f",j]];
        [itemJ addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [kdj_j addObject:itemJ];
    }
    [dic setObject:kdj_k forKey:@"kdj_k"];
    [dic setObject:kdj_d forKey:@"kdj_d"];
    [dic setObject:kdj_j forKey:@"kdj_j"];
    
    //VR
    NSMutableArray *vr = [[NSMutableArray alloc] init];
    for (int i = 0; i<24; i++) { //补充数据
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%d",invalidData]];
        [item addObject:@"0000-00-00"];
        [vr addObject:item];
        
    }
    
    for(int i = 24;i < data.count;i++){
        float inc = 0;
        float dec = 0;
        float eq  = 0;
        for(int j=i;j>i-24;j--){
            float o = [[[data objectAtIndex:j] objectAtIndex:0] floatValue];
            float c = [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            
            if(c > o){
                inc += [[[data objectAtIndex:j] objectAtIndex:4] intValue];
            }else if(c < o){
                dec += [[[data objectAtIndex:j] objectAtIndex:4] intValue];
            }else{
                eq  += [[[data objectAtIndex:j] objectAtIndex:4] intValue];
            }
        }
        
        float val = (inc+1*eq/2)/(dec+1*eq/2);
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [item addObject:[[data objectAtIndex:i] objectAtIndex:5]]; //日期
        [vr addObject:item];
    }
    [dic setObject:vr forKey:@"vr"];
    
    
}

-(void)setData:(NSDictionary *)dic{
    [self.candleChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
    [self.candleChart appendToData:[dic objectForKey:@"vol"] forName:@"vol"];
    
    [self.candleChart appendToData:[dic objectForKey:@"ma5"] forName:@"ma5"];
    [self.candleChart appendToData:[dic objectForKey:@"ma10"] forName:@"ma10"];
    [self.candleChart appendToData:[dic objectForKey:@"ma20"] forName:@"ma20"];
    [self.candleChart appendToData:[dic objectForKey:@"ma30"] forName:@"ma30"];
    
    [self.candleChart appendToData:[dic objectForKey:@"rsi6"] forName:@"rsi6"];
    [self.candleChart appendToData:[dic objectForKey:@"rsi12"] forName:@"rsi12"];
    [self.candleChart appendToData:[dic objectForKey:@"rsi24"] forName:@"rsi24"];
    
    [self.candleChart appendToData:[dic objectForKey:@"wr"] forName:@"wr"];
    [self.candleChart appendToData:[dic objectForKey:@"vr"] forName:@"vr"];
    
    [self.candleChart appendToData:[dic objectForKey:@"kdj_k"] forName:@"kdj_k"];
    [self.candleChart appendToData:[dic objectForKey:@"kdj_d"] forName:@"kdj_d"];
    [self.candleChart appendToData:[dic objectForKey:@"kdj_j"] forName:@"kdj_j"];
    
}

-(void)setCategory:(NSArray *)category{
    [self.candleChart appendToCategory:category forName:@"price"];
    [self.candleChart appendToCategory:category forName:@"line"];
}

@end
