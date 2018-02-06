//
//  MemoryInfo.m
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "MemoryInfo.h"

@implementation MemoryInfo

@synthesize name = _name;
@synthesize manufacturer = _manufacturer;
@synthesize partNumber = _partNumber;
@synthesize serialNumber = _serialNumber;
@synthesize size = _size;
@synthesize speed = _speed;
@synthesize status = _status;
@synthesize type = _type;

- (instancetype)init {
    
    self = [self initWithName:nil
                 manufacturer:nil
                   partNumber:nil
                 serialNumber:nil
                         size:nil
                        speed:nil
                       status:nil
                         type:nil];
    
    return self;
    
}

- (instancetype)initWithName:(NSString *)name manufacturer:(NSString *)manufacturer partNumber:(NSString *)partNumber serialNumber:(NSString *)serialNumber size:(NSString *)size speed:(NSString *)speed status:(NSString *)status type:(NSString *)type {
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _manufacturer = manufacturer;
        _partNumber = partNumber;
        _serialNumber = serialNumber;
        _size = size;
        _speed = speed;
        _status = status;
        _type = type;
        
    }
    
    return self;
    
}

@end
