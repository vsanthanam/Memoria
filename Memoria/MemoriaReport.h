//
//  MemoriaReport.h
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, MemoriaReportResult) {
    
    MemoriaReportResultUnknown = 0,
    MemoriaReportResultSuccess = 1,
    MemoriaReportResultFailure = 2
    
};

@interface MemoriaReport : NSObject

@property (assign) MemoriaReportResult testResult;
@property (strong, nullable) NSString *resultDescription;

@property (assign) NSInteger availableAmount;
@property (assign) NSInteger requestedAmount;
@property (assign) NSInteger allocatedAmount;

@property (strong, nullable) NSDate *startTime;
@property (strong, nullable) NSDate *stopTime;
@property (assign) NSInteger executionTime;

@property (assign) NSInteger totalCycles;
@property (assign) NSInteger completedCycles;

@property (strong, nullable) NSArray<NSString *> *logItems;

- (nullable NSAttributedString *)createReport;

- (void)addLogItem:(nonnull NSString *)logItem;

@end
