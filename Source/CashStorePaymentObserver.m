//
//  CashStorePaymentObserver.m
//  bacterial
//
//  Created by 李翌文 on 14-7-3.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CashStorePaymentObserver.h"

@implementation CashStorePaymentObserver

static CashStorePaymentObserver *_sharedCashStorePaymentObserver = nil;

+(CashStorePaymentObserver *)sharedCashStorePaymentObserver
{
    if(!_sharedCashStorePaymentObserver)
    {
        _sharedCashStorePaymentObserver = [[CashStorePaymentObserver alloc] init];
    }
    return _sharedCashStorePaymentObserver;
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            {
                NSString *receipt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
                NSLog(@"%@", receipt);
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
                NSLog(@"failed");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"restored");
                break;
            default:
                break;
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"transaction removed!");
}

@end
