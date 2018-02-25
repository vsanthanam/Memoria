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

- (IBAction)userSave:(id)sender {
    
//    NSSavePanel *savePanel = [NSSavePanel savePanel];
//
//    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse response) {
//
//    }];
    
}

- (IBAction)userDiscard:(id)sender {
    
    [self.view.window.sheetParent endSheet:self.view.window];
    
}
@end
