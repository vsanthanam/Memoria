//
//  MemoryInfoManager.m
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoryInfoManager.h"

@implementation MemoryInfoManager

@synthesize delegate = _delegate;

- (void)getMemoryInfo {
    
    NSString *memoryInfoTemporaryFile = [NSString stringWithFormat:@"%@/com.varunsanthanam.Memoria.MemoryInfo.plist", NSHomeDirectory()];
    NSString *memoryInfoCommand = [NSString stringWithFormat:@"system_profiler SPMemoryDataType -xml > %@", memoryInfoTemporaryFile];
    
    system(memoryInfoCommand.UTF8String);
    
    NSArray *memoryInfoArray = [NSArray arrayWithContentsOfFile:memoryInfoTemporaryFile];
    
    NSError *memoryInfoError;
    [[NSFileManager defaultManager] removeItemAtPath:memoryInfoTemporaryFile error:&memoryInfoError];
    
    NSDictionary *payload = memoryInfoArray[0];
    
    NSArray *payloads = payload[@"_items"][0][@"_items"];
    
    NSArray<MemoryInfo *> *memoryInfo = [[NSArray<MemoryInfo *> alloc] init];
    
    for (NSDictionary *payload in payloads) {
        
        MemoryInfo *info = [[MemoryInfo alloc] initWithName:payload[@"_name"]
                                               manufacturer:payload[@"dimm_manufacturer"]
                                                 partNumber:payload[@"dimm_part_number"]
                                               serialNumber:payload[@"dimm_serial_number"]
                                                       size:payload[@"dimm_size"]
                                                      speed:payload[@"dimm_speed"]
                                                     status:payload[@"dimm_status"]
                                                       type:payload[@"dimm_type"]];
        
        memoryInfo = [memoryInfo arrayByAddingObject:info];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(memoryInfoManager:didRecieveMemoryInfo:)]) {
        
        [self.delegate memoryInfoManager:self
                    didRecieveMemoryInfo:memoryInfo];
        
    }
    
}

@end
