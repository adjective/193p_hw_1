//
//  CalculatorBrain.m
//  CalculatorProduct
//
//  Created by HaoQi on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if(_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    //NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    //[self.operandStack addObject:operandObject];
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}
- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject)[self.operandStack removeLastObject];
    return [operandObject doubleValue];
}
- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]){
        
        //result = [self popOperand] + [self popOperand];
        double first = [self popOperand];
        double second = [self popOperand];
        result = first + second;
    } else if ([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand]/divisor;
        
    } else if ([operation isEqualToString:@"sin"]){
        double topnum = [self popOperand];
        result = sin(topnum);
    } else if ([operation isEqualToString:@"cos"]){
        double topnum = [self popOperand];
        result = cos(topnum);
    } else if ([operation isEqualToString:@"sqrt"]){
        double topnum = [self popOperand];
        result = sqrt(topnum);
    } else if ([operation isEqualToString:@"pi"]){
        result = M_PI;
    }
    
    [self pushOperand:result];
    
    return result;
}

- (void)performClear
{
    [self.operandStack removeAllObjects];
}
@end
