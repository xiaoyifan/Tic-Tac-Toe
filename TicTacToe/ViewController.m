//
//  ViewController.m
//  TicTacToe
//
//  Created by XiaoYifan on 2/6/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)panLetterX:(UIPanGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:[sender view]];
    NSLog(@"x is %f, y is %f", touchPoint.x, touchPoint.y);
    
    UIView *piece = [sender view];
    [[piece superview] bringSubviewToFront:piece];
    
    if([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged){
        
        CGPoint translation  = [sender translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [sender setTranslation:CGPointZero inView:[piece superview]];
        
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self detectIntersect:self.letterX];
    }

}

- (IBAction)panLetterO:(UIPanGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:[sender view]];
    NSLog(@"x is %f, y is %f", touchPoint.x, touchPoint.y);
    
    UIView *piece = [sender view];
    [[piece superview] bringSubviewToFront:piece];
    
    if([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged){
        
        CGPoint translation  = [sender translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [sender setTranslation:CGPointZero inView:[piece superview]];
        
        
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self detectIntersect:self.letterO];
    }

}


-(void)detectIntersect:(UIImageView *)myView{
    
    for (int i=1; i<9; i++) {
        UIView *currentView = [[self view] viewWithTag:i];
        if (CGRectIntersectsRect(currentView.frame, myView.frame)) {
            NSLog(@"View Intersect with number %d view", i);
        }
    }
}


@end
