//
//  MemoriaViewController.m
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoriaViewController.h"

#import "MemoryInfoManager.h"
#import "MemoriaTask.h"

@interface MemoriaViewController ()<MemoryInfoManagerDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *memoryInfoTableView;
@property (weak) IBOutlet NSTextField *amounTextField;
@property (weak) IBOutlet NSButton *allMemoryCheckBox;
@property (weak) IBOutlet NSTextField *cyclesTextField;
@property (weak) IBOutlet NSButton *maximumCyclesTextField;
@property (weak) IBOutlet NSProgressIndicator *taskStatusProgressBar;
@property (weak) IBOutlet NSTextField *cyclesLabel;
@property (weak) IBOutlet NSButton *startStopButton;

@property (readonly) MemoryInfoManager *memoryInfoManager;
@property NSArray<MemoryInfo *> *memoryInfo;

@property MemoriaTask *task;

@end

@implementation MemoriaViewController {
    
    int _cycles;
    int _pid;
    
}

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

#pragma mark - MemoriaTaskDelegate

- (void)memoriaTaskDidStartProcess:(MemoriaTask *)task {
    
}

- (void)memoriaTaskDidEndProcess:(MemoriaTask *)task {
    
}

- (void)memoriaTask:(MemoriaTask *)task didSendOutputStringFromProcess:(NSString *)outputString {
    
}

#pragma mark - Private Instance Methods

- (void)_setUpMemoriaUI {
    
    [self _setUpMemoryInfoTableView];
    
}

- (void)_setUpMemoryInfoTableView {
 
    self.memoryInfoTableView.delegate = self;
    self.memoryInfoTableView.dataSource = self;
    
}

- (void)_getMemoryInfo {
    
    [self.memoryInfoManager getMemoryInfo];
    
}

- (void)_startTest {
    
    _cycles = [self.cyclesTextField intValue];
    
    NSString *cyclesString = [self.cyclesTextField stringValue];
    NSString *amountString = self.allMemoryCheckBox.state ? @"all" : [self.amounTextField stringValue];
    
    NSString *mtpath = [[NSBundle mainBundle] pathForResource:@"memtest" ofType:nil];
    
    _pid = [self _openTask:mtpath withArguments:@[amountString, cyclesString]];
    
    
}

- (void)_stopTest {
    
    [self.task endProcess];
    
}

- (int)_openTask:(NSString *)path withArguments:(NSArray<NSString *> *)arguments {
    
    NSMutableArray<NSString *> *args = [[NSMutableArray<NSString *> alloc] init];
    
    [args addObject:path];
    [args addObjectsFromArray:arguments];

    if (self.task.running) {
        
        [self.task endProcess];
        
    }
    
    self.task = [[MemoriaTask alloc] initWithDelegate:self arguments:args];
    [self.task startProcess];
    
    int pid = self.task.pid;
    
    return pid;
    
}

#pragma mark - Actions

- (IBAction)userStartStopTest:(id)sender {
    
    if (!self.task.running) {
        
        [self _startTest];
        
    } else {
        
        [self _stopTest];
        
    }
    
}

@end
