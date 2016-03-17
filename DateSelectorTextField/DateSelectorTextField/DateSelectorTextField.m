//
//  DateSelectorTextField.m
//  WokeOnDeveloping
//
//  Created by 金秋成 on 16/3/16.
//  Copyright © 2016年 蓝兔子. All rights reserved.
//

#import "DateSelectorTextField.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

@implementation DateSelectorTextFieldModel


@end


@interface DateSelectorTextField ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UIPickerView * datePickerView;
@property (nonatomic,strong)UIView       * accesseryView;
@property (nonatomic,strong)NSDateFormatter * formatter;
@property (nonatomic,strong)NSMutableArray  * data;
@end

@implementation DateSelectorTextField



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
    self.inputView = self.datePickerView;
    self.inputAccessoryView = self.accesseryView;
    
    if (self.selectorMode == DateSelectorTextFieldModeYearMonthDate) {
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
        [self.datePickerView selectRow:[[self.data objectAtIndex:1] count]-1 inComponent:1 animated:NO];
        [self.datePickerView selectRow:[[self.data objectAtIndex:2] count]-1 inComponent:2 animated:NO];
    }
    else if (self.selectorMode == DateSelectorTextFieldModeYearMonth){
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
        [self.datePickerView selectRow:[[self.data objectAtIndex:1] count]-1 inComponent:1 animated:NO];
    }
    else if (self.selectorMode == DateSelectorTextFieldModeYear){
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
    }
    else if (self.selectorMode == DateSelectorTextFieldModeBodyLength){
        [self.datePickerView selectRow:[[self.data objectAtIndex:0] count]-1 inComponent:0 animated:NO];
    }
    
}

-(UIPickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _datePickerView.dataSource = self;
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

-(UIView *)accesseryView{
    if (!_accesseryView) {
        _accesseryView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        _accesseryView.backgroundColor = [UIColor whiteColor];
        UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_accesseryView addSubview:cancelBtn];
        [_accesseryView addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_accesseryView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15]];
        [_accesseryView addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_accesseryView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_accesseryView addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_accesseryView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _accesseryView;
}
-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}
-(void)dateDidChange:(UIDatePicker *)sender{
    self.text = [self.formatter stringFromDate:sender.date];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:self];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextDidEndEditingNotification object:sender];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelBtnClick:(UIButton *)sender{
//    self.text = [self.formatter stringFromDate:self.datePickerView.date];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
//        [self.delegate textFieldDidEndEditing:self];
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextDidEndEditingNotification object:sender];
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
//    [self resignFirstResponder];
}

//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [(DateSelectorTextFieldModel *)[[self.data objectAtIndex:component] objectAtIndex:row] value];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (self.selectorMode) {
        case DateSelectorTextFieldModeYearMonthDate:
            [self remakeData];
            
            break;
        case DateSelectorTextFieldModeYearMonth:
            [self remakeData];
            break;
        case DateSelectorTextFieldModeYear:
            break;
        case DateSelectorTextFieldModeBodyLength:
            break;
        default:
            break;
    }
    
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    switch (self.selectorMode) {
        case DateSelectorTextFieldModeYearMonthDate:
            return [self.data[component]count];
            break;
        case DateSelectorTextFieldModeYearMonth:
            return [self.data[component]count];
            break;
        case DateSelectorTextFieldModeYear:
            return [self.data[component]count];
        case DateSelectorTextFieldModeBodyLength:
            return [self.data[component]count];
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger componentsCount = 0;
    
    switch (self.selectorMode) {
        case DateSelectorTextFieldModeYearMonthDate:
            componentsCount = 3;
            break;
        case DateSelectorTextFieldModeYearMonth:
            componentsCount = 2;
            break;
        case DateSelectorTextFieldModeYear:
            componentsCount = 1;
            break;
        case DateSelectorTextFieldModeBodyLength:
            componentsCount = self.data.count;
        default:
            break;
    }
    
    return componentsCount;
}
-(void)setSelectorMode:(DateSelectorTextFieldMode)selectorMode{
    _selectorMode = selectorMode;
    switch (selectorMode) {
        case DateSelectorTextFieldModeYearMonthDate:{
            NSInteger currentDay = [[NSDate date] day];
            NSMutableArray * dateArr = [NSMutableArray new];
            for (NSInteger i = 1;i <= currentDay; i++) {
                DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
                model.code = [NSString stringWithFormat:@"%.2ld",i];
                model.value= [NSString stringWithFormat:@"%ld日",i];
                [dateArr addObject:model];
            }
            [self.data insertObject:dateArr atIndex:0];
        }
        case DateSelectorTextFieldModeYearMonth:{
            NSInteger currentMonth = [[NSDate date] month];
            NSMutableArray * monthArr = [NSMutableArray new];
            for (NSInteger i = 1;i <= currentMonth; i++) {
                DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
                model.code = [NSString stringWithFormat:@"%.2ld",i];
                model.value= [NSString stringWithFormat:@"%ld月",i];
                [monthArr addObject:model];
            }
            [self.data insertObject:monthArr atIndex:0];
        }
        case DateSelectorTextFieldModeYear:{
            NSInteger currentYear = [[NSDate date] year];
            NSMutableArray * yearArr = [NSMutableArray new];
            for (NSInteger i = currentYear-100;i <= currentYear; i++) {
                DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
                model.code = [NSString stringWithFormat:@"%ld",i];
                model.value= [NSString stringWithFormat:@"%ld年",i];
                [yearArr addObject:model];
            }
            [self.data insertObject:yearArr atIndex:0];
        }
            break;
        case DateSelectorTextFieldModeBodyLength:{
            NSMutableArray * blArr = [NSMutableArray new];
            for (NSInteger i = 130;i <250; i++) {
                DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
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
}


-(void)remakeData{
    
    if (self.selectorMode == DateSelectorTextFieldModeYearMonthDate) {
        [self remakeMonth];
        [self remakeDate];
    }
    else if(self.selectorMode == DateSelectorTextFieldModeYearMonth){
        [self remakeMonth];
    }

}

-(void)remakeMonth{
    DateSelectorTextFieldModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
    NSInteger loopCount =  12;
    NSMutableArray * monthArr = [NSMutableArray new];
    if (yearModel.code.integerValue == [[NSDate date] year]) {
        loopCount = [[NSDate date] month];
        for (NSInteger i = 1;i <= loopCount; i++) {
            DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld月",i];
            [monthArr addObject:model];
        }
        [self.data replaceObjectAtIndex:1 withObject:monthArr];
    }
    else{
        for (NSInteger i = 1;i <= loopCount; i++) {
            DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld月",i];
            [monthArr addObject:model];
        }
        [self.data replaceObjectAtIndex:1 withObject:monthArr];
    }
    [self.datePickerView reloadComponent:1];
}

-(void)remakeDate{
    DateSelectorTextFieldModel * yearModel = [[self.data objectAtIndex:0] objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
    DateSelectorTextFieldModel * monthModel = [[self.data objectAtIndex:1] objectAtIndex:[self.datePickerView selectedRowInComponent:1]];
//    DateSelectorTextFieldModel * dateModel = [[self.data objectAtIndex:2] objectAtIndex:[self.datePickerView selectedRowInComponent:2]];
    NSLog(@"%ld  %ld",monthModel.code.integerValue,[NSDate date].month);
    if (monthModel.code.integerValue == [NSDate date].month&&
        yearModel.code.integerValue == [NSDate date].year) {
        NSMutableArray * dateArr = [NSMutableArray new];
        for (NSInteger i = 1;i <= [NSDate date].day; i++) {
            DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
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
            DateSelectorTextFieldModel * model = [[DateSelectorTextFieldModel alloc]init];
            model.code = [NSString stringWithFormat:@"%.2ld",i];
            model.value= [NSString stringWithFormat:@"%ld日",i];
            [dateArr addObject:model];
        }
        [self.data replaceObjectAtIndex:2 withObject:dateArr];
    }
    
    
    [self.datePickerView reloadComponent:2];
}



-(NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

@end
