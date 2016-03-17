//
//  WKDateSelector.m
//  DateSelectorTextField
//
//  Created by Nicolas on 16/3/17.
//  Copyright © 2016年 蓝兔子. All rights reserved.
//

#import "WKDateSelector.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

@implementation WKDateSelectorModel



@end


@interface WKDateSelector ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIPickerView * datePickerView;
@property (nonatomic,strong)NSMutableArray  * data;
@end


@implementation WKDateSelector

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)awakeFromNib{
    [self commonInit];
}
- (void)commonInit{
    self.tintColor = [UIColor clearColor];
    [self addSubview:self.datePickerView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    
}



-(UIPickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.dataSource = self;
        _datePickerView.delegate = self;
        _datePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _datePickerView;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [(WKDateSelectorModel *)[[self.data objectAtIndex:component] objectAtIndex:row] value];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (self.selectorMode) {
        case WKDateSelectorModeYearMonthDate:
            [self remakeData];
            break;
        case WKDateSelectorModeYearMonth:
            [self remakeData];
            break;
        case WKDateSelectorModeYear:
            [self remakeData];
            break;
        case WKDateSelectorModeLength:
            break;
        default:
            break;
    }

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger componentCount = [self.data[component]count];
    return componentCount;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger componentsCount = 0;
    
    switch (self.selectorMode) {
        case WKDateSelectorModeYearMonthDate:
            componentsCount = 3;
            break;
        case WKDateSelectorModeYearMonth:
            componentsCount = 2;
            break;
        case WKDateSelectorModeYear:
            componentsCount = 1;
            break;
        case WKDateSelectorModeLength:
            componentsCount = 1;//self.data.count;
            break;
        default:
            componentsCount = 1;
            break;
    }
    return componentsCount;
}
-(void)setSelectorMode:(WKDateSelectorMode)selectorMode{
    _selectorMode = selectorMode;
    
    [self.data removeAllObjects];
    switch (selectorMode) {
        case WKDateSelectorModeYearMonthDate:{
            NSInteger currentDay = [[NSDate date] day];
            NSMutableArray * dateArr = [NSMutableArray new];
            for (NSInteger i = 1;i <= currentDay; i++) {
                WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
                model.code = [NSString stringWithFormat:@"%.2ld",i];
                model.value= [NSString stringWithFormat:@"%ld日",i];
                [dateArr addObject:model];
            }
            [self.data insertObject:dateArr atIndex:0];
        }
        case WKDateSelectorModeYearMonth:{
            NSInteger currentMonth = [[NSDate date] month];
            NSMutableArray * monthArr = [NSMutableArray new];
            for (NSInteger i = 1;i <= currentMonth; i++) {
                WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
                model.code = [NSString stringWithFormat:@"%.2ld",i];
                model.value= [NSString stringWithFormat:@"%ld月",i];
                [monthArr addObject:model];
            }
            [self.data insertObject:monthArr atIndex:0];
        }
        case WKDateSelectorModeYear:{
            NSInteger currentYear = [[NSDate date] year];
            NSMutableArray * yearArr = [NSMutableArray new];
            for (NSInteger i = currentYear-100;i <= currentYear; i++) {
                WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
                model.code = [NSString stringWithFormat:@"%ld",i];
                model.value= [NSString stringWithFormat:@"%ld年",i];
                [yearArr addObject:model];
            }
            [self.data insertObject:yearArr atIndex:0];
        }
            break;
        case WKDateSelectorModeLength:{
            NSMutableArray * blArr = [NSMutableArray new];
            for (NSInteger i = 130;i <250; i++) {
                WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
                model.code = [NSString stringWithFormat:@"%ld",i];
                model.value= [NSString stringWithFormat:@"%ld cm",i];
                [blArr addObject:model];
            }
            [self.data insertObject:blArr atIndex:0];
        }
            break;
        default:
            break;
    }
    
    [self.datePickerView reloadAllComponents];
    [self resetSelection];
}


-(void)remakeData{
    
    if (self.selectorMode == WKDateSelectorModeYearMonthDate) {
        [self remakeMonth];
        [self remakeDate];
    }
    else if(self.selectorMode == WKDateSelectorModeYearMonth){
        [self remakeMonth];
    }
    
}

-(void)remakeMonth{
    WKDateSelectorModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
    NSInteger loopCount =  12;
    NSMutableArray * monthArr = [NSMutableArray new];
    if (yearModel.code.integerValue == [[NSDate date] year]) {
        loopCount = [[NSDate date] month];
        for (NSInteger i = 1;i <= loopCount; i++) {
            WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld月",i];
            [monthArr addObject:model];
        }
        [self.data replaceObjectAtIndex:1 withObject:monthArr];
    }
    else{
        for (NSInteger i = 1;i <= loopCount; i++) {
            WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld月",i];
            [monthArr addObject:model];
        }
        [self.data replaceObjectAtIndex:1 withObject:monthArr];
    }
    [self.datePickerView reloadComponent:1];
}

-(void)remakeDate{
    WKDateSelectorModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
    WKDateSelectorModel * monthModel = [[self.data objectAtIndex:1] objectAtIndex:[self.datePickerView selectedRowInComponent:1]];
    
    NSLog(@"%ld  %ld",monthModel.code.integerValue,[NSDate date].month);
    if (monthModel.code.integerValue == [NSDate date].month&&
        yearModel.code.integerValue == [NSDate date].year) {
        NSMutableArray * dateArr = [NSMutableArray new];
        for (NSInteger i = 1;i <= [NSDate date].day; i++) {
            WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld日",i];
            [dateArr addObject:model];
        }
        [self.data replaceObjectAtIndex:2 withObject:dateArr];
    }
    else{
        NSDate * selectedDate = [[NSDateFormatter dateFormatterWithFormat:@"yyyy-MM"]dateFromString:[NSString stringWithFormat:@"%@-%@",yearModel.code,monthModel.code]];
        NSRange dayRange = [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:selectedDate];
        NSMutableArray * dateArr = [NSMutableArray new];
        for (NSInteger i = 1;i <= dayRange.length; i++) {
            WKDateSelectorModel * model = [[WKDateSelectorModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld日",i];
            [dateArr addObject:model];
        }
        [self.data replaceObjectAtIndex:2 withObject:dateArr];
    }
    
    
    [self.datePickerView reloadComponent:2];
}

-(void)resetSelection{
    if (self.selectorMode == WKDateSelectorModeYearMonthDate) {
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
        [self.datePickerView selectRow:[[self.data objectAtIndex:1] count]-1 inComponent:1 animated:NO];
        [self.datePickerView selectRow:[[self.data objectAtIndex:2] count]-1 inComponent:2 animated:NO];
    }
    else if (self.selectorMode == WKDateSelectorModeYearMonth){
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
        [self.datePickerView selectRow:[[self.data objectAtIndex:1] count]-1 inComponent:1 animated:NO];
    }
    else if (self.selectorMode == WKDateSelectorModeYear){
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
    }
    else if (self.selectorMode == WKDateSelectorModeLength){
        [self.datePickerView selectRow:45 inComponent:0 animated:NO];
    }
}
-(NSString *)getValue{
    
    NSString * value = [NSString new];
    if (self.selectorMode == WKDateSelectorModeYear) {
        WKDateSelectorModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
        value = yearModel.code;
    }
    else if (self.selectorMode == WKDateSelectorModeYearMonth){
        WKDateSelectorModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
        WKDateSelectorModel * monthModel = [[self.data objectAtIndex:1] objectAtIndex:[self.datePickerView selectedRowInComponent:1]];
        value = [NSString stringWithFormat:@"%@-%@",yearModel.code,monthModel.code];
    }
    else if (self.selectorMode == WKDateSelectorModeYearMonthDate){
        WKDateSelectorModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
        WKDateSelectorModel * monthModel = [[self.data objectAtIndex:1] objectAtIndex:[self.datePickerView selectedRowInComponent:1]];
        WKDateSelectorModel * dayModel   = [[self.data objectAtIndex:2] objectAtIndex:[self.datePickerView selectedRowInComponent:2]];
        value = [NSString stringWithFormat:@"%@-%@-%@",yearModel.code,monthModel.code,dayModel.code];
        
    }
    else if (self.selectorMode == WKDateSelectorModeLength){
        WKDateSelectorModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
        value = yearModel.code;
    }
    
    
    
    return value;
}
-(NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}
@end
