//
//  ViewController.h
//  DateSelectorTextField
//
//  Created by 金秋成 on 16/3/16.
//  Copyright © 2016年 蓝兔子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateSelectorTextField.h"
#import "WKDateSelector.h"
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet DateSelectorTextField *tf;
@property (weak, nonatomic) IBOutlet WKDateSelector *wkview;

@end

