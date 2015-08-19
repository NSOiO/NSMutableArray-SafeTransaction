//
//  main.m
//  NSMutableArray-Demo
//
//  Created by Deepak on 8/19/15.
//  Copyright (c) 2015 deepak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+SafeTransaction.h"

#define UseSafeTrasation 1

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        
        NSMutableArray *arr = [@[@"1",@"2",@"3"] mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (1) {
                @autoreleasepool {
#if UseSafeTrasation
                    id obj = [arr inReadTransaction:^id{
                        NSUInteger count = arr.count;
                        return arr[count - 1];
                    }];
                    
#else
                    NSUInteger count = arr.count;
                    id obj = arr[count-1];
#endif
                }
            }
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (1) {
                @autoreleasepool{
#if UseSafeTrasation
                    [arr inWriteTransaction:^{
                        
                        [arr removeLastObject];
                        [arr addObject:@"3"];
                    }];
#else
                    [arr removeLastObject];
                    [arr addObject:@"3"];
#endif
                }
            }
        });
    }
    sleep(1000);
    return 0;
}
