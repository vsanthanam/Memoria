//
//  MemoriaReport.m
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Cocoa;

#import "MemoriaReport.h"

@implementation MemoriaReport

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.testResult = MemoriaReportResultUnknown;
        self.logItems = [[NSArray<NSString *> alloc] init];
        
    }
    
    return self;
    
}

- (NSAttributedString *)createReport {
    
    NSError *error;
    
    NSMutableAttributedString *report = [[NSMutableAttributedString alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"MemoriaReport" withExtension:@"rtf"] options:@{} documentAttributes:nil error:&error];
    
    [report.mutableString replaceOccurrencesOfString:@"TEST_RESULTS"
                                          withString:self.resultDescription
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"AVAILABLE_MEMORY"
                                          withString:[NSString stringWithFormat:@"%li", self.availableAmount]
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"REQUESTED_AMOUNT"
                                          withString:[NSString stringWithFormat:@"%li", self.requestedAmount]
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"ALLOCATED_AMOUNT"
                                          withString:[NSString stringWithFormat:@"%li", self.allocatedAmount]
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"REQUESTED_CYCLES"
                                          withString:[NSString stringWithFormat:@"%li", self.totalCycles]
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"COMPLETED_CYCLES"
                                          withString:[NSString stringWithFormat:@"%li", self.completedCycles]
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"EXECUTION_TIME"
                                          withString:[NSString stringWithFormat:@"%li", self.executionTime]
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"START_DATE"
                                          withString:self.startTime.description
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    [report.mutableString replaceOccurrencesOfString:@"END_DATE"
                                          withString:self.stopTime.description
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, report.mutableString.length - 1)];
    
    for (NSString *logItem in self.logItems) {
        
        [report.mutableString appendString:logItem];
        
    }

    
    return [report copy];
    
}

- (void)addLogItem:(NSString *)logItem {
    
    self.logItems = [self.logItems arrayByAddingObject:logItem];
    
}

@end
