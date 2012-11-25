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
- (double)performOperation:(NSString *)operation;
- (void)performClear;

@property (nonatomic, readonly) id program;

+ (NSString *) descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
