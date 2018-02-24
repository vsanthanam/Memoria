//
//  Memoria.m
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import IOKit.pwr_mgt;

#import "Memoria.h"

#import "memoria_log.h"
#import "MemoriaTask.h"

@interface Memoria ()<MemoriaTaskDelegate>

@property (strong) MemoriaTask *task;
@property (strong) MemoriaReport *report;

@end

@implementation Memoria {
    
    NSInteger           _completedTests;
    IOPMAssertionID     _assertionID;
    NSArray<NSString *> *_testList;
    NSArray<NSString *> *_progressList;
    
}

@synthesize delegate = _delegate;
@synthesize amount = _amount;
@synthesize totalCycles = _totalCycles;
@synthesize completedCycles = _completedCycles;
@synthesize report = _report;

static os_log_t memtest_log;

#pragma mark - Overridden Class Methods

+ (void)initialize {
    
    memtest_log = memoria_log_create("memtest");
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithDelegate:nil amount:1 cycles:1];
    
    return self;
    
}

#pragma mark - Property Access Methods

- (int)pid {
    
    return self.task.pid;
    
}

- (BOOL)isRunning {
    
    return self.task.running;
    
}

- (double)progress {
    
    return ((double)_completedTests / (double)(self.totalCycles * _testList.count)) * 100.0f;
    
}

#pragma mark - MemoriaTaskDelegate

- (void)memoriaTaskDidStartProcess:(MemoriaTask *)task {
    
    [self _enableSleepPrevetion];
    
    if ([self.delegate respondsToSelector:@selector(memoriaDidStart:)]) {
        
        [self.delegate memoriaDidStart:self];
        
    }
    
}

- (void)memoriaTaskDidEndProcess:(MemoriaTask *)task {
    
    [self _disableSleepPrevention];
    
    if ([self.delegate respondsToSelector:@selector(memoriaDidEnd:)]) {
        
        [self.delegate memoriaDidEnd:self];
        
    }
    
}

- (void)memoriaTask:(MemoriaTask *)task didSendOutputStringFromProcess:(NSString *)outputString {
    
    if (!outputString) {
        
        return;
        
    }
    
    BOOL log = YES;
    
    for (NSString *_progress in _progressList) {
        
        if ([outputString rangeOfString:_progress].location != NSNotFound) {
            
            log = NO;
            
        }
        
    }
    
    if ([outputString rangeOfString:@"Memtest version"].location != NSNotFound) {
        
        log = YES;
        
        self.report.allocatedAmount = [[outputString componentsSeparatedByString:@"Allocated memory: "][1] componentsSeparatedByString:@"MB ("][0];
        self.report.availableAmount = [[outputString componentsSeparatedByString:@"Available memory: "][1] componentsSeparatedByString:@"MB ("][0];
        
    }
    
    if ([outputString rangeOfString:@"Test sequence"].location != NSNotFound) {
        
        log = YES;
        _completedCycles++;
        os_log(memoria_log(), "Test Sequence: %li", (NSInteger)_completedCycles);
        
        // update cycles count label.
        
    }
    
    for (NSString *test in _testList) {
        
        if ([outputString rangeOfString:test].location != NSNotFound) {
            
            log = YES;
            _completedTests++;
            
            if ([self.delegate respondsToSelector:@selector(memoria:didStartTest:)]) {
                
                [self.delegate memoria:self didStartTest:test];
                
            }
            
            os_log(memoria_log(), "Running Test: %@", test);
            
        }
        
    }
    
    if ([outputString rangeOfString:@"All tests passed!"].location != NSNotFound) {
        
        log = YES;
        
        self.report.testResults = MemoriaReportResultSuccess;
        self.report.memtestResults = @"All tests passed!";
        
        // update UI
        
        os_log(memoria_log(), "Tests Passed!");
        
    }
    
    if ([outputString rangeOfString:@"FAILURE!"].location != NSNotFound) {
        
        log = YES;
        
        // update ui
        
        self.report.testResults = MemoriaReportResultFailure;
        self.report.memtestResults = @"FAILURE!";
        
        os_log_error(memoria_log(), "Failed: %@", self.report.memtestResults);
        
    }
    
    if ([outputString rangeOfString:@"*** Address Test Failed ***"].location != NSNotFound) {
        
        log = YES;
        
        // update ui
        
        self.report.testResults = MemoriaReportResultFailure;
        self.report.memtestResults = @"*** Address Test Failed ***";
        
        os_log_error(memoria_log(), "Failed: %@", self.report.memtestResults);
        
    }
    
    if ([outputString rangeOfString:@"*** Memory Test Failed ***"].location != NSNotFound) {
        
        log = YES;
        
        // update ui
        
        self.report.testResults = MemoriaReportResultFailure;
        self.report.memtestResults = @"*** Memory Test Failed ***";
        
        os_log_error(memoria_log(), "Failed: %@", self.report.memtestResults);
        
    }
    
    if (log) {
        
        os_log_info(memtest_log, "%@", outputString);
        
    }
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<MemoriaDelegate>)delegate amount:(NSInteger)amount cycles:(NSInteger)cycles {
    
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
        
        _amount = amount;
        _totalCycles = cycles;
        
        _completedCycles = 0;
        _completedTests = 0;
        _testList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_list" ofType:@"plist"]];
        _progressList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"progress_list" ofType:@"plist"]];

        _report = [[MemoriaReport alloc] init];
        
    }
    
    return self;
    
}

- (void)start {
    
    // get memtest cli path
    NSString *mtpath = [[NSBundle mainBundle] pathForResource:@"memtest" ofType:nil];
    
    if (self.task.running) {
        
        [self.task endProcess];
        
    }
    
    NSString *amountString = self.amount == -1 ? @"all" : @(self.amount).stringValue;
    
    self.task = [[MemoriaTask alloc] initWithDelegate:self
                                            arguments:@[mtpath, amountString, @(self.totalCycles).stringValue]];
    
    [self.task startProcess];
    
}

- (void)stop {
    
    [self.task endProcess];
    
}

#pragma mark - Private Instance Methods

- (void)_enableSleepPrevetion {
    
    if (!_assertionID) {
        
        IOPMAssertionCreateWithName(kIOPMAssertionTypeNoIdleSleep, kIOPMAssertionLevelOn, CFSTR("Running Memtest"), &_assertionID);
        
    }
    
}

- (void)_disableSleepPrevention {
    
    if (_assertionID) {
        
        IOPMAssertionRelease(_assertionID);
        _assertionID = 0;
        
    }
    
}

@end
