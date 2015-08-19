//
//  NSMutableArray+SafeTrasaction.m
//  Delegate
//
//  Created by Deepak on 8/18/15.
//  Copyright (c) 2015 Glow, Inc. All rights reserved.
//

#import "NSMutableArray+SafeTransaction.h"
#import <objc/runtime.h>

@implementation NSMutableArray (SafeTransaction)

- (dispatch_queue_t)safeTrasaction_queue
{
    dispatch_queue_t q = objc_getAssociatedObject(self, _cmd);
    if (NULL == q) {
        // when access safeTrasaction_queue concurrently， be sure to create safeTrasaction_queue once.
        @synchronized(self) {
            q = objc_getAssociatedObject(self, _cmd);
            if (NULL == q) {
                q = dispatch_queue_create("MutableArray_SafeTrasaction_Queue", DISPATCH_QUEUE_CONCURRENT);
                self.safeTrasaction_queue = q;
            }
        }
    }
    
    return q;
}

- (void)setSafeTrasaction_queue:(dispatch_queue_t)queue
{
    objc_setAssociatedObject(self, @selector(safeTrasaction_queue), queue, OBJC_ASSOCIATION_RETAIN);
}

- (id)inReadTransaction:(id(^)(void))readBlock
{
    if (!readBlock) return nil;
    
    __block id obj;
    dispatch_sync(self.safeTrasaction_queue, ^{
        obj = readBlock();
    });
    return obj;
}

- (void)inWriteTransaction:(void (^)(void))writeBlock
{
    !writeBlock ?: dispatch_barrier_async(self.safeTrasaction_queue, writeBlock);
}


@end
