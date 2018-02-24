//
//  MemoriaReport.h
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, MemoriaReportResult) {
    
    MemoriaReportResultSuccess,
    MemoriaReportResultFailure
    
};

@interface MemoriaReport : NSObject

@property (assign) MemoriaReportResult testResults;
@property (strong, nullable) NSString *memtestResults;
@property (strong, nullable) NSString *availableAmount;
@property (strong, nullable) NSString *builtInAmount;
@property (strong, nullable) NSString *requestedAmount;
@property (strong, nullable) NSString *allocatedAmount;
@property (strong, nullable) NSString *totalCycles;
@property (strong, nullable) NSString *completedCycles;
@property (strong, nullable) NSString *executionTime;
@property (strong, nullable) NSString *startTime;
@property (strong, nullable) NSString *stopTime;

- (nullable NSAttributedString *)createReport;

@end