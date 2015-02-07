//
//  ViewController.m
//  TicTacToe
//
//  Created by XiaoYifan on 2/6/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property CGPoint *letterXOriginalPosition;
@property CGPoint *letterOOriginalPosition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //self.letterX.translatesAutoresizingMaskIntoConstraints = YES;
    //self.letterO.translatesAutoresizingMaskIntoConstraints = YES;
    //using this setting would free the layout constraints.
    
    [self disableLetterO];
}


#pragma mark - enable and disable of dragging image
-(void)disableLetterO{
    self.letterO.alpha = 0.5;
    self.letterO.userInteractionEnabled = NO;

}
// disable lette O, won't accept user interaction

-(void)disableLetterX{
    self.letterX.alpha = 0.5;
    self.letterX.userInteractionEnabled = NO;
    
}
// disable lette X, won't accept user interaction

-(void)enableLetterO{
    self.letterO.alpha = 1;
    self.letterO.userInteractionEnabled = YES;
    
}
// disable lette O, won't accept user interaction

-(void)enableLetterX{
    self.letterX.alpha = 1;
    self.letterX.userInteractionEnabled = YES;
    
}
// disable lette X, won't accept user interaction



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - gesture recognition
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
    
    for (int i=1; i<=9; i++) {
        UIView *currentView = [[self view] viewWithTag:i];
        if (CGRectIntersectsRect(currentView.frame, myView.frame)) {
            NSLog(@"View Intersect with number %d view", i);
            
            
            //if the intersection is detected, we gonna add the dragging image to the grid
            if ([self setImageOfView:myView toView:currentView] == FALSE) {
                
                //put the animation here and the gradding image will move back to the original position.
                
            }
            else{//if the image insertion is succeeded
                
                //detect if there's a winner
                //if not, we should switch to another player
                
                    //tag specification: 20 is X, 10 is O
                   if (myView.tag == 20) {
                       [self disableLetterX];
                       [self enableLetterO];
                    
                    }
                    else if(myView.tag == 10)
                    {
                       [self disableLetterO];
                       [self enableLetterX];
                    }
                
            }
            
            break;
            
        }
    }
}
//for reference
/*
    work to do:
    1. animation, if the grid is not empty, the view will roll back to the original position, 
        Two original position is set as property, get the value, implement the function with roll back
 
    2. animation of growing and shrinking. put the animation effect in a function, and call the function in the 
        enable function.
 
    3. detect winner
 
    4.
 
 
 */

-(Boolean)setImageOfView:(UIImageView *)dragging toView:(UIView *)grid{
    
    if (grid.subviews.count == 0) {
        
        UIImage *currentImage = dragging.image;
        UIImageView *subView = [[UIImageView alloc] initWithImage:currentImage];
        [grid addSubview:subView];
        
    }
    else{
        return false;
    }
    
    
    return true;
}


@end
