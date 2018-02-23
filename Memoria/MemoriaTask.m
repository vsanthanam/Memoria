//
//  MemoriaTask.m
//  Memoria
//
//  Created by Varun Santhanam on 2/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoriaTask.h"

@implementation MemoriaTask

@synthesize delegate = _delegate;
@synthesize task = _task;
@synthesize arguments = _arguments;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithDelegate:nil arguments:nil];
    
    return self;
    
}

#pragma mark - Property Access Methods

- (int)terminationStatus {
    
    return self.task.terminationStatus;
    
}

- (int)pid {
    
    return self.task.processIdentifier;
    
}

- (BOOL)isRunning {
    
    return self.task.running;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<MemoriaTaskDelegate>)delegate arguments:(nullable NSArray *)arguments {
    
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
        _arguments = [arguments copy];
        
    }
    
    return self;
    
}

- (void)startProcess {
    
    if ([self.delegate respondsToSelector:@selector(memoriaTaskDidStartProcess:)]) {
        
        [self.delegate memoriaTaskDidStartProcess:self];
        
    }
    
    _task = [[NSTask alloc] init];
    
    self.task.standardOutput = [NSPipe pipe];
    self.task.standardError = self.task.standardOutput;
    
    self.task.launchPath = self.arguments[0];
    self.task.arguments = [self.arguments subarrayWithRange:NSMakeRange(1, self.arguments.count - 1)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_getData:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:[self.task.standardOutput fileHandleForReading]];
    
    [[self.task.standardOutput fileHandleForReading] readInBackgroundAndNotify];
    
    [self.task launch];
    
}

- (void)endProcess {
    
    NSData *data;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSFileHandleReadCompletionNotification
                                                  object:[self.task.standardError fileHandleForReading]];
    
    [self.task terminate];
    [self.task waitUntilExit];
    
    while ((data == [self.task.standardOutput fileHandleForReading].availableData) && data.length) {
        
        if ([self.delegate respondsToSelector:@selector(memoriaTask:didSendOutputStringFromProcess:)]) {
            
            [self.delegate memoriaTask:self didSendOutputStringFromProcess:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(memoriaTaskDidEndProcess:)]) {
        
        [self.delegate memoriaTaskDidEndProcess:self];
        
    }
    
    self.delegate = nil;
    
}

#pragma mark - Private Instance Methods

- (void)_getData:(NSNotification *)notif {
 
    NSData *data = notif.userInfo[NSFileHandleNotificationDataItem];
    
    if (data.length) {
        
        if ([self.delegate respondsToSelector:@selector(memoriaTask:didSendOutputStringFromProcess:)]) {
            
            [self.delegate memoriaTask:self didSendOutputStringFromProcess:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            
        }
        
    } else {
        
        [self endProcess];
        
    }
    
    [notif.object readInBackgroundAndNotify];
    
}

@end
