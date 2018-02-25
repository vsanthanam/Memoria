//
//  MemoriaReportViewController.m
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoriaReportViewController.h"

@interface MemoriaReportViewController ()

@end

@implementation MemoriaReportViewController

- (void)viewWillAppear {
    
    [super viewWillAppear];
    
    NSLog(@"REPORT OBJ: %@", self.report);
    NSLog(@"%@", self.report.memtestResults);
    NSLog(@"%@", self.report.availableAmount);
    NSLog(@"%@", self.report.builtInAmount);
    NSLog(@"%@", self.report.requestedAmount);
    NSLog(@"%@", self.report.allocatedAmount);
    NSLog(@"%@", self.report.totalCycles);
    NSLog(@"%@", self.report.completedCycles);
    NSLog(@"%@", self.report.executionTime);
    NSLog(@"%@", self.report.startTime);
    NSLog(@"%@", self.report.stopTime);
    
}

@end
