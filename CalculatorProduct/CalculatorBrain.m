//
//  CalculatorBrain.m
//  CalculatorProduct
//
//  Created by HaoQi on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize testVariableValues = _testVariableValues;

- (NSMutableArray *)programStack
{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
- (NSDictionary *)testVariableValues{
    if(_testVariableValues == nil) _testVariableValues = [[NSDictionary alloc] init];

    return _testVariableValues;
}

- (id)program
{
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}
- (void) pushVariable:(NSString *) variable{
    [self.programStack addObject:variable];
}

- (NSString *)getDescription{
    NSLog(@"4444444444");
    return [[self class] descriptionOfProgram:self.program];
}
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result = @"";
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([[self typeOfObject:topOfStack] isEqualToString:@"NUMBER"]){
        result = [topOfStack stringValue];
        
    } else if ([[self typeOfObject:topOfStack] isEqualToString:@"2_OPERAND_OPERATION_WITH_PARENS"]){
        // Note: this keeps the parens of 1 + (2 + 3)
        NSString * secondOperand = [self descriptionOfTopOfStack:stack];
        result = [NSString stringWithFormat:@"(%@ %@ %@)",
                  [self descriptionOfTopOfStack:stack], topOfStack, secondOperand];
    } else if ([[self typeOfObject:topOfStack] isEqualToString:@"2_OPERAND_OPERATION"]){
        NSString * secondOperand = [self descriptionOfTopOfStack:stack];
        result = [NSString stringWithFormat:@"%@ %@ %@",
                  [self descriptionOfTopOfStack:stack], topOfStack, secondOperand];
        
    } else if ([[self typeOfObject:topOfStack] isEqualToString:@"1_OPERAND_OPERATION"]){
        NSString * inside = [self descriptionOfTopOfStack:stack];
        if ([inside hasPrefix:@"("] && [inside hasSuffix:@")"]){ // gets rid of inside parens of sqrt((3+5))
            result = [NSString stringWithFormat:@"%@%@",
                      topOfStack, inside];
        } else {
            result = [NSString stringWithFormat:@"%@(%@)",
                      topOfStack, inside];
        }
        
    } else { // @"0_OPERAND_OPERATION" || @"VARIABLE"
        result = topOfStack;
    }
   
    return result;
}
+ (NSString *)descriptionOfProgram:(id)program
{
    NSLog(@"555555555555");
    if ([program count] < 1){
        NSLog(@"666666666666");
        return @"";
    }
    NSLog(@"77777777777");
    NSLog(@"array count: %d", [program count]);
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    // record all the operations on the stack, top of stack first.
    NSString *result = @"";
    NSString *next_result = @"";
    while ([stack count] > 0){
        next_result = [self descriptionOfTopOfStack:stack];
        
        // remove the outer most parens of result
        if ([next_result hasPrefix:@"("] && [next_result hasSuffix:@")"]){
            next_result = [next_result substringWithRange:NSMakeRange(1, [next_result length]-2)];
        } 
        result = [NSString stringWithFormat:@"%@, %@",
                  result, next_result];
    }
    return [result substringFromIndex:2]; // get rid of the first ", "
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program
                usingVariableValues:self.testVariableValues];
} 

- (double)provideResultOfCurrentProgram{
    return [[self class] runProgram:self.program
                usingVariableValues:self.testVariableValues];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack]/divisor;
        } else if ([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"pi"]){
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues 
{
    if (!variableValues){
        return [self runProgram:program];
    }
    NSMutableArray *stackUsingVars;
    if ([program isKindOfClass:[NSArray class]]){
        stackUsingVars = [program mutableCopy];
        // change variables into their values, or 0 if undefined
        for (int i=0; i<[stackUsingVars count]; i++){
            id obj = [stackUsingVars objectAtIndex:i];
            if ([[self typeOfObject:obj] isEqualToString:@"VARIABLE"]){
                if ([obj isKindOfClass:[NSString class]]){
                    NSNumber *value = [variableValues objectForKey:obj];
                    // "if (value == nil)" is the same as "if (!value)"
                    if (!value){                        
                        // ! Cannot put 0 here, it's not an object somehowe
                        // with our code, can put any unreconizable string, including @"0" or @"haha", (but not @"+")
                        // if you put in @"333" it will still be an 0
                        // "[stackUsingVars replaceObjectAtIndex:i withObject:0];" 
                        //     does not work because numbers are not objects
                        [stackUsingVars replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                        
                    } else {
                        [stackUsingVars replaceObjectAtIndex:i withObject:value];
                    }

                }
            }
        }
    }
    return [self popOperandOffStack:stackUsingVars];
}

- (NSString *)getVarDisplay{
    if ([self.program count] < 1){
        return @"";
    }
    NSSet *varSet = [[self class] variablesUsedInProgram:self.program];
    NSString *result = @"";
    for (NSString *var in varSet){
        NSString *value = [self.testVariableValues objectForKey:var];
        if (!value) {value = @"0";}
        result = [NSString stringWithFormat:@"%@ %@ = %@  ",
                  result, var, value];
                  
    }
    return result;
}

- (void)setTest:(NSString *)testName{
    if ([testName isEqualToString:@"Test 1"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:(-4)], @"x", 
                               [NSNumber numberWithInt:3], @"a", 
                               [NSNumber numberWithInt:4], @"b", 
                               nil];
    } else if ([testName isEqualToString:@"Test 2"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:(-4)], @"x", 
                                   [NSNumber numberWithDouble:5.5], @"a", 
                                   [NSNumber numberWithInt:4], @"b", 
                                   nil];
    } else if ([testName isEqualToString:@"Test 3"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:(-4)], @"x", 
                                   nil, @"a", 
                                   nil, @"b", 
                                   nil];
    } else if ([testName isEqualToString:@"Test Null"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil, @"x", 
                                   nil, @"a", 
                                   nil, @"b", 
                                   nil];
    }
}

// gets all the names of variables used in a given program (NSSet of NSString)
+ (NSSet *)variablesUsedInProgram:(id)program{    
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];

    for (id obj in program){
        if ([obj isKindOfClass:[NSString class]]){
            if (![self isOperation:obj]){
                [variableSet addObject:obj];
            }
        }
    }
    // if program has no variables, return nil
    return (![variableSet count]) ? nil : variableSet;
}

   
- (void)performClear
{
    [self.programStack removeAllObjects];
}

- (void)removeStackTop{
    [self.programStack removeLastObject];
}

+ (NSString *)typeOfObject:(id)obj{
    NSString *type = @"";
    if ([obj isKindOfClass:[NSNumber class]]){
        type = @"NUMBER";
    } else if ([obj isKindOfClass:[NSString class]]){
        if ([[NSSet setWithObjects:@"+",@"-",nil] containsObject:obj]){
            type = @"2_OPERAND_OPERATION_WITH_PARENS";
        } else if ([[NSSet setWithObjects:@"*",@"/",nil] containsObject:obj]){
            type = @"2_OPERAND_OPERATION";
        } else if ([[NSSet setWithObjects:@"sin",@"cos",@"sqrt",nil] containsObject:obj]){
            type = @"1_OPERAND_OPERATION";
        } else if ([[NSSet setWithObjects:@"pi",nil] containsObject:obj]){
            type = @"0_OPERAND_OPERATION";
        } else { // assuming that any non-operation string is a var
            type = @"VARIABLE";
        }
    }
    return type;
}

+ (BOOL)isOperation:(NSString *)operation{
    NSSet *operators = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt",@"pi",nil];
    return [operators containsObject:operation];
}

@end
