//
//  MemoriaTask.h
//  Memoria
//
//  Created by Varun Santhanam on 2/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@class MemoriaTask;

@protocol MemoriaTaskDelegate<NSObject>

@optional

- (void)memoriaTaskDidStartProcess:(nonnull MemoriaTask *)task;
- (void)memoriaTaskDidEndProcess:(nonnull MemoriaTask *)task;
- (void)memoriaTask:(nonnull MemoriaTask *)task didSendOutputStringFromProcess:(nullable NSString *)outputString;

@end

@interface MemoriaTask : NSObject

@property (weak, nullable) id<MemoriaTaskDelegate> delegate;

@property (strong, readonly, nullable) NSTask *task;
@property (strong, readonly, nullable) NSArray<NSString *> *arguments;

@property (readonly) int terminationStatus;
@property (readonly) int pid;
@property (readonly, getter=isRunning) BOOL running;

- (nullable instancetype)initWithDelegate:(nullable id<MemoriaTaskDelegate>)delegate arguments:(nullable NSArray<NSString *> *)arguments NS_DESIGNATED_INITIALIZER;

- (void)startProcess;
- (void)endProcess;

@end
