//
//  MemoriaViewController.m
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoriaViewController.h"

#import "MemoryInfoManager.h"

@interface MemoriaViewController ()<MemoryInfoManagerDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *memoryInfoTableView;

@property (strong, readonly) MemoryInfoManager *memoryInfoManager;
@property (strong) NSArray<MemoryInfo *> *memoryInfo;

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

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//
//
//
//}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    MemoryInfo *info = self.memoryInfo[row];
    
    if ([tableColumn.identifier isEqualToString:@"StatusColumnID"]) {
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"StatusCellID" owner:nil];
        
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

@end
