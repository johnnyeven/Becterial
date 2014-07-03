//
//  CashStoreManager.h
//  bacterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashStoreManager : NSObject
<SKProductsRequestDelegate>

+(CashStoreManager *)sharedCashStoreManager;
-(void)validateProductIdentifiers:(NSArray *)productIdentifiers;

@end
