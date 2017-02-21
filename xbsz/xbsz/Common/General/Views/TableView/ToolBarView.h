//
//  ToolBarView.h
//  xbsz
//
//  Created by 陈鑫 on 17/2/21.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ToolBarActionType){
    ToolBarClickTypeLike = 1<<0,       //点赞
    ToolBarClickTypeReply = 1<<1,       //回复
    ToolBarClickTypeShare = 1<<2,       //分享
    ToolBarClickTypeMore = 1<<3         //更多
};

@class ToolBarView;
typedef   void(^ToolBarActionBlock)(ToolBarView *view , id model , ToolBarActionType actionType);


@interface ToolBarView : UIView

- (void)updateUIWithModel:(id) model action:(ToolBarActionBlock)actionBlock;

@end
