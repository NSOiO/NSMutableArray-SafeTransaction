//
//  NSMutableArray+SafeTrasaction.h
//  Delegate
//
//  Created by Deepak on 8/18/15.
//  Copyright (c) 2015 Glow, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (DP_ThreadSafeTransaction)

- (id)dp_readTransaction:(id(^)(void))readBlock;
- (void)dp_writeTransaction:(void (^)(void))writeBlock;

@end
