//
//  memoria_log.m
//  Memoria
//
//  Created by Varun Santhanam on 2/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "memoria_log.h"

os_log_t memoria_log_create(const char *category) {
    
    return os_log_create(memoria_log_subsystem, category);
    
}
