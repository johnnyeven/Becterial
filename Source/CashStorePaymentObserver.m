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

-(id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deliverComplete:) name:@"deliverComplete" object:nil];
    }

    return self;
}

-(void)didReceiveFromServer:(NSNotification *)notification
{
    NSDictionary *data = [notification object];
    int code = [[data objectForKey:@"code"] intValue];
    if(code == 1001)
    {
        NSString *identifier = [data objectForKey:@"identifier"];
        NSArray *items = [data objectForKey:@"items"];
        [self deliverProduct:items withIdentifier:identifier];
    }
}

-(void)deliverProduct:(NSArray *)items withIdentifier:(NSString *)identifier
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
        identifier, @"identifier",
        items, @"items", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deliverProduct"　object:data];
}

-(void)deliverComplete:(NSNotification *)notification
{
    NSDictionary *data = [notification object];
    NSString *identifier = [data objectForKey:@"identifier"];
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
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFromServer:) name:@"checkReceipt" object:nil];
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                    receipt, @"receipt", nil];
                [[PZWebManager sharedPZWebManager] asyncPostRequest:@"https://b.profzone.net/configuration/product_id" withData:data];

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
