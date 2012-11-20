//
//  CalculatorViewController.m
//  CalculatorProduct
//
//  Created by HaoQi on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// N.B.: NSLog(@"digit pressed = %@", digit);

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

-(CalculatorBrain *)brain{
    if (!_brain)_brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    NSString *space = @" ";
    self.history.text = [[self.history.text stringByAppendingString:space] stringByAppendingString:self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)[self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    NSString *space = @" ";
    NSString *equals = @" =";
    self.history.text = [[[self.history.text stringByAppendingString:space] stringByAppendingString:sender.currentTitle] stringByAppendingString:equals];
}

- (IBAction)decimalPressed {
    NSRange decimalRange = [self.display.text rangeOfString:@"."];
    if (decimalRange.location == NSNotFound){
        if (self.userIsInTheMiddleOfEnteringANumber){
            self.display.text = [self.display.text stringByAppendingString:@"."];
        } else {
            self.display.text = @"0.";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
    // else if decimal is already pressed, just ignore that press
}

- (IBAction)clearPressed {
    self.history.text = @"";
    self.display.text = @"0";
    [self.brain performClear];
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
