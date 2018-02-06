//
//  MemoryInfo.h
//  Memoria
//
//  Created by Varun Santhanam on 2/6/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface MemoryInfo : NSObject

@property (strong, readonly, nullable) NSString *name;
@property (strong, readonly, nullable) NSString *manufacturer;
@property (strong, readonly, nullable) NSString *partNumber;
@property (strong, readonly, nullable) NSString *serialNumber;
@property (strong, readonly, nullable) NSString *size;
@property (strong, readonly, nullable) NSString *speed;
@property (strong, readonly, nullable) NSString *status;
@property (strong, readonly, nullable) NSString *type;

- (nullable instancetype)initWithName:(nullable NSString *)name manufacturer:(nullable NSString *)manufacturer partNumber:(nullable NSString *)partNumber serialNumber:(nullable NSString *)serialNumber size:(nullable NSString *)size speed:(nullable NSString *)speed status:(nullable NSString *)status type:(nullable NSString *)type NS_DESIGNATED_INITIALIZER;

@end
