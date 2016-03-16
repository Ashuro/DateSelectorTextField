//
//  DateSelectorTextField.m
//  WokeOnDeveloping
//
//  Created by 金秋成 on 16/3/16.
//  Copyright © 2016年 蓝兔子. All rights reserved.
//

#import "DateSelectorTextField.h"



@interface DateSelectorTextField ()<UIPickerViewDelegate>
@property (nonatomic,strong)UIDatePicker * datePickerView;
@property (nonatomic,strong)UIView       * accesseryView;
@property (nonatomic,strong)NSDateFormatter * formatter;
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
    
}

-(UIDatePicker *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        _datePickerView.maximumDate = [NSDate date];
        _datePickerView.timeZone = [NSTimeZone systemTimeZone];
        [_datePickerView addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
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
    self.text = [self.formatter stringFromDate:self.datePickerView.date];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:self];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextDidEndEditingNotification object:sender];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self resignFirstResponder];
}


@end
