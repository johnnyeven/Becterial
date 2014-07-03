//
//  CashStoreManager.m
//  bacterial
//
//  Created by 李翌文 on 14-7-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "CashStoreManager.h"

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
	// self.products = response.products;
 
	_products = response.products;
    _invalidProducts = response.invalidProductIdentifiers;
}

@end