//
//  DateSelectorTextField.h
//  WokeOnDeveloping
//
//  Created by 金秋成 on 16/3/16.
//  Copyright © 2016年 蓝兔子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DateSelectorTextFieldMode) {
    DateSelectorTextFieldModeYearMonthDate,
    DateSelectorTextFieldModeYearMonth,
    DateSelectorTextFieldModeYear,
    DateSelectorTextFieldModeBodyLength,
};


@interface DateSelectorTextFieldModel : NSObject
@property (nonatomic,strong)NSString * code;
@property (nonatomic,strong)NSString * value;

@end


@interface DateSelectorTextField : UITextField
@property (nonatomic,assign)DateSelectorTextFieldMode selectorMode;

@end
