//
//  memoria_log.h
//  Memoria
//
//  Created by Varun Santhanam on 2/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#ifndef memoria_log_h
#define memoria_log_h


#endif /* memoria_log_h */

#import <os/log.h>

#define memoria_log_subsystem "com.varunsanthanam.Memoria"

os_log_t memoria_log_create(const char *category);

os_log_t memoria_log(void);
