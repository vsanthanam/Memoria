//
//  Memoria.h
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

#import "MemoriaReport.h"

@class Memoria;

@protocol MemoriaDelegate<NSObject>

@optional

- (void)memoriaDidStart:(nonnull Memoria *)memoria;
- (void)memoriaDidEnd:(nullable Memoria *)memoria;

- (void)memoria:(nonnull Memoria *)memoria didStartTest:(nullable NSString *)test;

@end

@interface Memoria : NSObject

@property (weak, nullable) id<MemoriaDelegate> delegate;
@property (assign, readonly) NSInteger amount;
@property (assign, readonly) NSInteger totalCycles;
@property (assign, readonly) NSInteger completedCycles;
@property (strong, readonly, nullable) MemoriaReport *report;

@property (readonly) int pid;
@property (readonly, getter=isRunning) BOOL running;
@property (readonly) double progress;

- (nullable instancetype)initWithDelegate:(nullable id<MemoriaDelegate>)delegate amount:(NSInteger)amount cycles:(NSInteger)cycles NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)stop;

@end
