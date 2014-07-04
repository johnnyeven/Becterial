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
-(void)didReceiveFromServer:(NSNotification *)notification;
-(void)deliverProduct:(NSArray *)items withIdentifier:(NSString *)identifier;
-(void)deliverComplete:(NSNotification *)notification;

@end
