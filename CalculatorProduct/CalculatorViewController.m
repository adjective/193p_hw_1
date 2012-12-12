//
//  CalculatorViewController.m
//  CalculatorProduct
//
//  Created by HaoQi on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// N.B.: NSLog(@"digit pressed = %@", digit);
// Notes:
// - !!! I made the mistake of putting variables inside CalculatorBrian !!!
//      See correct solution here: https://github.com/m2mtech/Calculator/blob/Assignment2MandatoryTasks/Calculator/CalculatorViewController.m
// - The history label is left in for debugging, it's not required anymore in assignment, it's not updated during undo
// - I should have an updateDisplay function, too lazy, too late oh well

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize description = _description;
@synthesize vardisplay = _vardisplay;
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
    
    self.description.text = [self.brain getDescription];
    self.vardisplay.text = [self.brain getVarDisplay];

}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)[self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    NSString *space = @" ";
    NSString *equals = @" =";
    self.history.text = [[[self.history.text stringByAppendingString:space] stringByAppendingString:sender.currentTitle] stringByAppendingString:equals];
    
    self.description.text = [self.brain getDescription];
    self.vardisplay.text = [self.brain getVarDisplay];

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
    self.description.text = @"";
    self.vardisplay.text = @"";
    self.display.text = @"0";
        [self.brain performClear];
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)[self enterPressed];
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
    self.history.text = [[self.history.text stringByAppendingString:@" "] stringByAppendingString:sender.currentTitle];
    
    self.description.text = [self.brain getDescription];
    self.vardisplay.text = [self.brain getVarDisplay];
}
- (IBAction)testPressed:(UIButton *)sender {
    [self.brain setTest:sender.currentTitle];
}
- (IBAction)undoPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
        // take back last digit, if display cleared entirely, show result of current program
        if ([self.display.text length] >= 1){
            self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
            return;
        } else {
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        // Hitting Undo when the user is not in the middle of typing
        // should remove the top item from the program stack in the brain and update the userinterface.
        [self.brain removeStackTop];
    }
    double result = [self.brain provideResultOfCurrentProgram];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.description.text = [self.brain getDescription];
    self.vardisplay.text = [self.brain getVarDisplay];
}


- (void)viewDidUnload {
    [self setHistory:nil];
    [self setDescription:nil];
    [self setVardisplay:nil];
    [super viewDidUnload];
}
@end
