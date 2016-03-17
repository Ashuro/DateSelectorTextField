//
//  WKDateSelector.h
//  DateSelectorTextField
//
//  Created by Nicolas on 16/3/17.
//  Copyright © 2016年 蓝兔子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WKDateSelectorMode) {
    WKDateSelectorModeYearMonthDate,
    WKDateSelectorModeYearMonth,
    WKDateSelectorModeYear,
    WKDateSelectorModeLength,
};
@interface WKDateSelectorModel : NSObject
@property (nonatomic,strong)NSString * code;
@property (nonatomic,strong)NSString * value;
@end
@interface WKDateSelector : UIControl
@property (nonatomic,assign)WKDateSelectorMode selectorMode;
@property (nonatomic,strong)NSString * value;
@end
