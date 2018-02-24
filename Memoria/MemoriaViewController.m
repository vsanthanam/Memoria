//
//  MemoriaViewController.m
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoriaViewController.h"

#import "memoria_log.h"
#import "MemoryInfoManager.h"
#import "Memoria.h"
#import "MemoriaReportViewController.h"

@interface MemoriaViewController ()<MemoryInfoManagerDelegate, NSTableViewDelegate, NSTableViewDataSource, MemoriaDelegate>

@property (weak) IBOutlet NSTableView *memoryInfoTableView;
@property (weak) IBOutlet NSTextField *amounTextField;
@property (weak) IBOutlet NSButton *allMemoryCheckBox;
@property (weak) IBOutlet NSTextField *cyclesTextField;
@property (weak) IBOutlet NSButton *maximumCyclesCheckBox;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSTextField *cyclesLabel;
@property (weak) IBOutlet NSButton *startStopButton;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *statusLabel;

@property (strong, readonly) MemoryInfoManager *memoryInfoManager;
@property (strong) NSArray<MemoryInfo *> *memoryInfo;

@property (strong) Memoria *memoria;

@end

@implementation MemoriaViewController

@synthesize memoryInfoTableView = _memoryInfoTableView;
@synthesize memoryInfoManager = _memoryInfoManager;
@synthesize memoryInfo = _memoryInfo;

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _setUpMemoriaUI];
    
    [self _getMemoryInfo];

}

#pragma mark - Property Access Methods

- (MemoryInfoManager *)memoryInfoManager {
    
    if (!_memoryInfoManager) {
        
        _memoryInfoManager = [[MemoryInfoManager alloc] init];
        _memoryInfoManager.delegate = self;
        
    }
    
    return _memoryInfoManager;
    
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.memoryInfo.count;
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    MemoryInfo *info = self.memoryInfo[row];
    
    if ([tableColumn.identifier isEqualToString:@"StatusColumnID"]) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"StatusCellID" owner:nil];
        
        cellView.objectValue = info.status;
        
        if ([info.status isEqualToString:@"ok"]) {
            
            cellView.imageView.image = [NSImage imageNamed:@"green_status"];
            
        } else if ([info.status isEqualToString:@"failed"]){
            
            cellView.imageView.image = [NSImage imageNamed:@"red_status"];
            
        } else if ([info.status isEqualToString:@"empty"]) {
            
            cellView.imageView.image = [NSImage imageNamed:@"white_status"];
            
        } else {
            
            cellView.imageView.image = [NSImage imageNamed:@"white_status"];
            
        }
                
        return cellView;
        
    }
    
    if ([tableColumn.identifier isEqualToString:@"SlotColumnID"]) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SlotCellID" owner:nil];
        
        cellView.objectValue = info.name;
        cellView.textField.stringValue = info.name;
        
        return cellView;
        
    }
    
    if ([tableColumn.identifier isEqualToString:@"SizeColumnID"]) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SizeCellID" owner:nil];
        
        cellView.objectValue = info.size;
        cellView.textField.stringValue = info.size;
        
        return cellView;
        
    }
    
    if ([tableColumn.identifier isEqualToString:@"SpeedColumnID"]) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SpeedCellID" owner:nil];
        
        cellView.objectValue = info.speed;
        cellView.textField.stringValue = info.speed;
        
        return cellView;
        
    }
    
    if ([tableColumn.identifier isEqualToString:@"TypeColumnID"]) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"TypeCellID" owner:nil];
        
        cellView.objectValue = info.type;
        cellView.textField.stringValue = info.type;
        
        return cellView;
        
    }
    
    return nil;
    
}

#pragma mark - MemoryInfoManagerDelegate

- (void)memoryInfoManager:(MemoryInfoManager *)manager didRecieveMemoryInfo:(NSArray<MemoryInfo *> *)memoryInfo {
    
    self.memoryInfo = memoryInfo;
    [self.memoryInfoTableView reloadData];
    
}

#pragma mark - MemoriaDelegate

- (void)memoriaDidStart:(Memoria *)memoria {
    
    [self.progressIndicator startAnimation:nil];
    
}

- (void)memoriaDidEnd:(Memoria *)memoria {
    
    [self.progressIndicator stopAnimation:nil];
    
}

- (void)memoria:(Memoria *)memoria didStartTest:(NSString *)test {
    
    [self _setStatusLabelText:test];
    self.progressBar.doubleValue = memoria.progress;
    
    self.cyclesLabel.stringValue = [NSString stringWithFormat:@"Completed %li of %li", (long)memoria.completedCycles, (long)memoria.totalCycles];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpMemoriaUI {
    
    [self _setUpMemoryInfoTableView];
    [self _setUpProgressBar];
    [self _setUpStatusLabel];
    [self _setUpCyclesLabel];
    
}

- (void)_setUpMemoryInfoTableView {
 
    self.memoryInfoTableView.delegate = self;
    self.memoryInfoTableView.dataSource = self;
    
}

- (void)_setUpProgressBar {
    
    self.progressBar.usesThreadedAnimation = YES;
    self.progressBar.minValue = 0.0f;
    self.progressBar.maxValue = 100.0f;
    
}

- (void)_setUpStatusLabel {
    
    [self _setStatusLabelText:@""];
    
}

- (void)_setUpCyclesLabel {
    
    self.cyclesLabel.stringValue = @"";
    
}

- (void)_getMemoryInfo {
    
    [self.memoryInfoManager getMemoryInfo];
    
}

- (void)_startTest {
    
    // Validate memory test settings
    if (!self.allMemoryCheckBox.state  && self.amounTextField.doubleValue < 1) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = NSLocalizedString(@"Invalid Amount", nil);
        alert.informativeText = NSLocalizedString(@"Please enter a valid amount of memory in MB, or choose ""All Available Memory""", nil);
        
        [alert runModal];
        
        return;
        
    } else if (!self.maximumCyclesCheckBox.state && (self.cyclesTextField.doubleValue < 1 || self.cyclesTextField.doubleValue > 255)) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = NSLocalizedString(@"Invalid Amount", nil);
        alert.informativeText = NSLocalizedString(@"Please enter a valid cycle count (1-255), or chose ""Maximum""", nil);
        
        [alert runModal];
        
        return;
        
    }
    
    self.memoria = [[Memoria alloc] initWithDelegate:self
                                              amount:self.allMemoryCheckBox.state ? -1 : self.amounTextField.integerValue
                                              cycles:self.maximumCyclesCheckBox.state ? 255 : self.cyclesTextField.integerValue];
    [self.memoria start];
    
}

- (void)_stopTest {
    
    [self.memoria stop];
    
}

- (void)_setStatusLabelText:(NSString *)text {
    
    self.statusLabel.stringValue = text;
    
}

- (void)_showReport:(id)sender {
    
    NSWindowController *windowController = (NSWindowController *)[[NSStoryboard storyboardWithName:@"MemoriaReport" bundle:[NSBundle mainBundle]] instantiateInitialController];
    MemoriaReportViewController *viewController = (MemoriaReportViewController *)windowController.window.contentViewController;
    viewController.report = self.memoria.report;
    
    [self.view.window beginSheet:windowController.window completionHandler:nil];
    
}

#pragma mark - Actions

- (IBAction)userStartStopTest:(id)sender {
    
    if (!self.memoria.running) {

        [self _startTest];

    } else {

        [self _stopTest];

    }
    
}

@end
