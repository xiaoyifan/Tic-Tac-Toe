//
//  ViewController.m
//  TicTacToe
//
//  Created by XiaoYifan on 2/6/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface ViewController ()<UIAlertViewDelegate>
{
    SystemSoundID applause;
    SystemSoundID openGrid;
    SystemSoundID buzzer;
    SystemSoundID woosh;

}


@property CGPoint letterXOriginalPosition;
@property CGPoint letterOOriginalPosition;

@property NSMutableArray *status;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //self.letterX.translatesAutoresizingMaskIntoConstraints = YES;
    //self.letterO.translatesAutoresizingMaskIntoConstraints = YES;
    //using this setting would free the layout constraints.
    
    self.letterXOriginalPosition = self.letterX.center;
    self.letterOOriginalPosition = self.letterO.center;
    //save the original positon of two dragging image to the property,
    //it will be used in the animation.
    self.status = [[NSMutableArray alloc]init];
    
    for (int i=0; i<9; i++) {
        [self.status addObject:@"N"];
    }
    
    [self disableLetterO];
    
    [self loadAudios];
    
    [[self view]viewWithTag:50].hidden = YES;
}

-(void)loadAudios{
    NSURL *Audience_Applause   = [[NSBundle mainBundle] URLForResource: @"Audience_Applause" withExtension: @"mp3"];
    //initialize SystemSounID variable with file URL
    AudioServicesCreateSystemSoundID (CFBridgingRetain(Audience_Applause), &applause);
    
    NSURL *Buzzer_Sound   = [[NSBundle mainBundle] URLForResource: @"Buzzer_Sound" withExtension: @"mp3"];
    //initialize SystemSounID variable with file URL
    AudioServicesCreateSystemSoundID (CFBridgingRetain(Buzzer_Sound), &buzzer);
    
    NSURL *glass_ping   = [[NSBundle mainBundle] URLForResource: @"glass_ping" withExtension: @"mp3"];
    //initialize SystemSounID variable with file URL
    AudioServicesCreateSystemSoundID (CFBridgingRetain(glass_ping), &openGrid);

    NSURL *wooshSound   = [[NSBundle mainBundle] URLForResource: @"woosh" withExtension: @"mp3"];
    //initialize SystemSounID variable with file URL
    AudioServicesCreateSystemSoundID (CFBridgingRetain(wooshSound), &woosh);

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
    [self viewSizeChangeOnYourTurn:self.letterO];
    
}
// disable lette O, won't accept user interaction

-(void)enableLetterX{
    self.letterX.alpha = 1;
    self.letterX.userInteractionEnabled = YES;
    [self viewSizeChangeOnYourTurn:self.letterX];
    
}
// disable lette X, won't accept user interaction

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - gesture recognition
- (IBAction)panLetterX:(UIPanGestureRecognizer *)sender {
    
    UIView *piece = [sender view];
    [[piece superview] bringSubviewToFront:piece];
    
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        AudioServicesPlaySystemSound(woosh);
    }
    
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

    
    UIView *piece = [sender view];
    [[piece superview] bringSubviewToFront:piece];
    
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        AudioServicesPlaySystemSound(woosh);
    }
    
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
                //Animation method call here
                
                AudioServicesPlaySystemSound(buzzer);
                [self movingBackAnimation:myView];
                
            }
            else{//if the image insertion is succeeded
                
                char ch;
                
                if(myView.tag == 20){
                    [self.status replaceObjectAtIndex:i-1 withObject:@"X"];
                    ch = 'X';
                }
                else{
                    [self.status replaceObjectAtIndex:i-1 withObject:@"O"];
                    ch = 'O';
                }
                
                
                if ([self checkIfWinTheGame]) {
                    
                    [[self lineView] setHidden:NO];
                    
                    AudioServicesPlaySystemSound(applause);
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"%c wins the game",ch] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                else if([self checkGameEven]){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Ends Even" message:[NSString stringWithFormat:@"press ok to restart"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                
                AudioServicesPlaySystemSound(openGrid);
                
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

-(void)refreshGame{
 
    for (int i =1; i<=9; i++) {
        [[[[self view]viewWithTag:i] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int i=0; i<9; i++) {
        [self.status replaceObjectAtIndex:i withObject:@"N"];
    }
    
    [self disableLetterO];
    [self enableLetterX];
    [[self view]viewWithTag:50].hidden = YES;
}

-(Boolean)setImageOfView:(UIImageView *)dragging toView:(UIView *)grid{
    
    if (grid.subviews.count == 0) {
        
        UIImage *currentImage = dragging.image;
        UIImageView *subView = [[UIImageView alloc] initWithImage:currentImage];
        subView.tag = 0;
        [grid addSubview:subView];
    }
    else{
        return false;
    }
    
    return true;
}

-(BOOL)checkIfWinTheGame{
    //this tag is to be used to distinguish the X and O
    //X is for 20. and O is for 10
    
    if (([[self.status objectAtIndex:0] isEqualToString:[self.status objectAtIndex:1]])&& ([[self.status objectAtIndex:1] isEqualToString:[self.status objectAtIndex:2]]) && (![[self.status objectAtIndex:2] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:1].center;
        self.lineView.point2 = [self.view viewWithTag:3].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    
    if (([[self.status objectAtIndex:3] isEqualToString:[self.status objectAtIndex:4]])&& ([[self.status objectAtIndex:4] isEqualToString:[self.status objectAtIndex:5]]) && (![[self.status objectAtIndex:5] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:4].center;
        self.lineView.point2 = [self.view viewWithTag:6].center;
        
        [self.lineView setNeedsDisplay];
        
       
        return true;
    }
    if (([[self.status objectAtIndex:6] isEqualToString:[self.status objectAtIndex:7]])&& ([[self.status objectAtIndex:7] isEqualToString:[self.status objectAtIndex:8]]) && (![[self.status objectAtIndex:8] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:7].center;
        self.lineView.point2 = [self.view viewWithTag:9].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    
    
    if (([[self.status objectAtIndex:0] isEqualToString:[self.status objectAtIndex:3]])&& ([[self.status objectAtIndex:3] isEqualToString:[self.status objectAtIndex:6]]) && (![[self.status objectAtIndex:6] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:1].center;
        self.lineView.point2 = [self.view viewWithTag:7].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    
    if (([[self.status objectAtIndex:1] isEqualToString:[self.status objectAtIndex:4]])&& ([[self.status objectAtIndex:4] isEqualToString:[self.status objectAtIndex:7]]) && (![[self.status objectAtIndex:7] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:2].center;
        self.lineView.point2 = [self.view viewWithTag:8].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    if (([[self.status objectAtIndex:2] isEqualToString:[self.status objectAtIndex:5]])&& ([[self.status objectAtIndex:5] isEqualToString:[self.status objectAtIndex:8]]) && (![[self.status objectAtIndex:8] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:3].center;
        self.lineView.point2 = [self.view viewWithTag:9].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    
    if (([[self.status objectAtIndex:0] isEqualToString:[self.status objectAtIndex:4]])&& ([[self.status objectAtIndex:4] isEqualToString:[self.status objectAtIndex:8]]) && (![[self.status objectAtIndex:8] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:1].center;
        self.lineView.point2 = [self.view viewWithTag:9].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    
    if (([[self.status objectAtIndex:2] isEqualToString:[self.status objectAtIndex:4]])&& ([[self.status objectAtIndex:4] isEqualToString:[self.status objectAtIndex:6]]) && (![[self.status objectAtIndex:6] isEqualToString:@"N"])) {
        
        self.lineView.point1 = [self.view viewWithTag:3].center;
        self.lineView.point2 = [self.view viewWithTag:7].center;
        
        [self.lineView setNeedsDisplay];
        
        return true;
    }
    
    return false;
}

-(BOOL)checkGameEven{
    for (int i=0; i<9; i++) {
        if ([[self.status objectAtIndex:i] isEqualToString:@"N"]) {
            return false;
        }
    }
    return true;
}

#pragma mark - animations
-(void)movingBackAnimation:(UIImageView *)draggingView{
    [UIView animateWithDuration:0.8 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                     
                         if (draggingView.tag == 10) {
                             draggingView.center = self.letterOOriginalPosition;
                         }
                         else if(draggingView.tag == 20){
                             draggingView.center = self.letterXOriginalPosition;
                         }
                     
                     }
                     completion:^(BOOL completed){
                         NSLog(@"View %ld is moved back",(long)draggingView.tag);
                     }
     ];
}

-(void)viewSizeChangeOnYourTurn:(UIImageView *)nowView{
    
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         nowView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         
                     }
                     completion:^(BOOL completed){
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              nowView.transform = CGAffineTransformIdentity;
                                              
                                          }
                          ];
                         
                     }
     ];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"Cancel the alertView and refresh for new game.");
    [self refreshGame];
}

@end
