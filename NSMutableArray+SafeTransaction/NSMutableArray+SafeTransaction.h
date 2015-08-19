//
//  NSMutableArray+SafeTrasaction.h
//  Delegate
//
//  Created by Deepak on 8/18/15.
//  Copyright (c) 2015 Glow, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SafeTransaction)

- (id)inReadTransaction:(id(^)(void))readBlock;
- (void)inWriteTransaction:(void (^)(void))writeBlock;

@end
