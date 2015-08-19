//
//  NSMutableArray+SafeTrasaction.m
//  Delegate
//
//  Created by Deepak on 8/18/15.
//  Copyright (c) 2015 Glow, Inc. All rights reserved.
//

#import "NSMutableArray+DP_ThreadSafeTransaction.h"
#import <objc/runtime.h>

@implementation NSMutableArray (DP_ThreadSafeTransaction)

- (dispatch_queue_t)dp_safeTransactionQueue
{
    dispatch_queue_t q = objc_getAssociatedObject(self, _cmd);
    
    if (NULL == q) {
        // when access safeTrasaction_queue concurrently， be sure to create safeTrasaction_queue once.
        @synchronized(self) {
            q = objc_getAssociatedObject(self, _cmd);
            if (NULL == q) {
                q = dispatch_queue_create("MutableArray_SafeTrasaction_Queue", DISPATCH_QUEUE_CONCURRENT);
                self.dp_safeTransactionQueue = q;
            }
        }
    }
    
    return q;
}

- (void)setDp_safeTransactionQueue:(dispatch_queue_t)queue
{
    objc_setAssociatedObject(self, @selector(dp_safeTransactionQueue), queue, OBJC_ASSOCIATION_RETAIN);
}

- (id)dp_readTransaction:(id(^)(void))readBlock
{
    if (!readBlock) return nil;
    
    __block id obj;
    dispatch_sync(self.dp_safeTransactionQueue, ^{
        obj = readBlock();
    });
    return obj;
}

- (void)dp_writeTransaction:(void (^)(void))writeBlock
{
    !writeBlock ?: dispatch_barrier_async(self.dp_safeTransactionQueue, writeBlock);
}


@end
