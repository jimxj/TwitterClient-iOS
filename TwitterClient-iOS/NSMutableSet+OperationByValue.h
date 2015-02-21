//
// Created by Jim Liu on 2/19/15.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (OperationByValue)

- (void)intersectSetByValue:(NSSet *)otherSet;

- (void)minusSetByValue:(NSSet *)otherSet;

- (BOOL)containsObjectByValue:(id)anObject;

- (void)addObjectByValue:(id)object;

@end