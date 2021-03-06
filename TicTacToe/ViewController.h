//
//  ViewController.h
//  TicTacToe
//
//  Created by XiaoYifan on 2/6/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "drawLineView.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *letterX;

@property (weak, nonatomic) IBOutlet UIImageView *letterO;

@property (weak, nonatomic) IBOutlet drawLineView *lineView;

@property (weak, nonatomic) IBOutlet UIView *infoSheetView;


@end

