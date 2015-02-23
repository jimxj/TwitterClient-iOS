//
// Created by Jim Liu on 2/19/15.
//

#import "NSMutableSet+OperationByValue.h"
#import "MTLModel.h"


@implementation NSMutableSet (OperationByValue)

- (void)intersectSetByValue:(NSSet *)otherSet {
    if(!otherSet || !otherSet.count) {
        return;
    }

    __block NSMutableSet *itemsToBeRemoved = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        BOOL found = NO;
        for(id targetObj in otherSet) {
           if([obj isEqual:targetObj]) {
               found = YES;
               break;
           }
        }

        if(!found) {
            [itemsToBeRemoved addObject:obj];
        }
    }];

    if(itemsToBeRemoved.count) {
        [self minusSet:itemsToBeRemoved];
    }
}

- (void)minusSetByValue:(NSSet *)otherSet {
    if(!otherSet || !otherSet.count) {
        return;
    }

    __block NSMutableSet *itemsToBeRemoved = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        BOOL found = NO;
        for(id targetObj in otherSet) {
            if([obj isEqual:targetObj]) {
                found = YES;
                break;
            }
        }

        if(found) {
            [itemsToBeRemoved addObject:obj];
        }
    }];

    if(itemsToBeRemoved.count) {
        [self minusSet:itemsToBeRemoved];
    }
}

- (BOOL)containsObjectByValue:(id)anObject {
    if(!anObject) {
        return NO;
    }

    __block BOOL result = NO;
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if([obj isEqual:anObject]) {
            result = YES;
            *stop = YES;
        }
    }];

    return result;
}

- (void)addObjectByValue:(id)object {
    if(!object) {
        return;
    }

    __block BOOL found = NO;
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if([obj isEqual:object]) {
            found = YES;
            *stop = YES;
        }
    }];

    if(!found) {
        [self addObject:object];
    }
}

@end