//
//  DoHomeworkViewController.h
//  xbsz
//
//  Created by lotus on 2017/5/17.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import "CXWhitePushViewController.h"
#import "Homework.h"

@interface DoHomeworkViewController : CXWhitePushViewController

@property (nonatomic, assign) BOOL hasRightAnswer;

@property (nonatomic, assign) BOOL hasPracticed;

@property (nonatomic, strong) Homework *homework;

@end
