//
//  MemoryInfoManager.h
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

#import "MemoryInfo.h"

@class MemoryInfoManager;

@protocol MemoryInfoManagerDelegate<NSObject>

@optional

- (void)memoryInfoManager:(nonnull MemoryInfoManager *)manager didRecieveMemoryInfo:(nonnull NSArray<MemoryInfo *> *)memoryInfo;

@end

@interface MemoryInfoManager : NSObject

@property (weak, nullable) id<MemoryInfoManagerDelegate> delegate;

- (void)getMemoryInfo;

@end
