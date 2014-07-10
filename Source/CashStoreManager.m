//
//  CashStoreManager.m
//  bacterial
//
//  Created by 李翌文 on 14-7-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "CashStoreManager.h"
#import "DataStorageManager.h"

@implementation CashStoreManager

static CashStoreManager *_instance = nil;

+(CashStoreManager *)sharedCashStoreManager
{
	if(!_instance)
	{
		_instance = [[CashStoreManager alloc] init];
	}

	return _instance;
}

-(void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
	SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
	initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
	productsRequest.delegate = self;
	[productsRequest start];
}

-(void)purchaseProduct:(NSString *)identifier
{
    SKProduct *product;
    for (product in _products)
    {
        if([product.productIdentifier isEqualToString:identifier])
        {
            break;
        }
    }
    
    if(product)
    {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	_products = response.products;
    _invalidProducts = response.invalidProductIdentifiers;
    
    NSMutableArray *array = [NSMutableArray new];
    for (SKProduct *product in _products)
    {
        NSMutableDictionary *p = [NSMutableDictionary new];
        [p setObject:product.productIdentifier forKey:@"productIdentifier"];
        [p setObject:product.localizedTitle forKey:@"localizedTitle"];
        [p setObject:product.localizedDescription forKey:@"localizedDescription"];
        [p setObject:product.price.stringValue forKey:@"price"];
        [array addObject:p];
    }

    NSMutableDictionary *config = [[DataStorageManager sharedDataStorageManager].config objectForKey:@"products"];
    if(!config)
    {
        config = [NSMutableDictionary new];
        [config setObject:[NSDictionary new] forKey:@"version"];
    }
    else
    {
        [[DataStorageManager sharedDataStorageManager].config setObject:array forKey:@"result"];
    }
    [[DataStorageManager sharedDataStorageManager] saveConfig];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoadingIcon" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCashStoreView" object:nil];
}

@end