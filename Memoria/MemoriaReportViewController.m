//
//  MemoriaReportViewController.m
//  Memoria
//
//  Created by Varun Santhanam on 2/24/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoriaReportViewController.h"

@interface MemoriaReportViewController ()

@property (weak) IBOutlet NSTextView *reportTextView;

@end

@implementation MemoriaReportViewController

- (void)viewWillAppear {
    
    [super viewWillAppear];
    
    [self.reportTextView.textStorage appendAttributedString:[self.report createReport]];
    
}

@end
