//
//  CalculatorBrain.h
//  CalculatorProduct
//
//  Created by HaoQi on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void) pushVariable:(NSString *)variable;
- (double)performOperation:(NSString *)operation;
- (double)provideResultOfCurrentProgram;
- (void)performClear;
- (void)removeStackTop;

@property (nonatomic, readonly) id program;

- (NSString *) getDescription;
- (NSString *) getVarDisplay;
- (void)setTest:(NSString *)testName;
+ (NSString *) descriptionOfProgram:(id)program;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;

+ (NSSet *)variablesUsedInProgram:(id)program;
+ (NSString *)typeOfObject:(id) obj;
+ (BOOL)isOperation:(NSString *)operation;

@end
