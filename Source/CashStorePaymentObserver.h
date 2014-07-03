//
//  CashStorePaymentObserver.h
//  bacterial
//
//  Created by 李翌文 on 14-7-3.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface CashStorePaymentObserver : NSObject
<SKPaymentTransactionObserver>

+(CashStorePaymentObserver *)sharedCashStorePaymentObserver;

@end
