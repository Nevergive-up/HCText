//
//  HCTextField.m
//  LianBu
//
//  Created by 衡前进 on 2018/12/10.
//  Copyright © 2018 HelloC. All rights reserved.
//

#import "HCTextField.h"

@implementation HCTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(select:)) { //禁止粘贴
        return NO;
    }
    if (action == @selector(selectAll:)) { //禁止粘贴
        return NO;
    }
    if (action == @selector(paste:)) { //禁止粘贴
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
