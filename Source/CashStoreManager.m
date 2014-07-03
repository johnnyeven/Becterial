//
//  CashStoreManager.m
//  bacterial
//
//  Created by 李翌文 on 14-7-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CashStoreManager.h"

@implementation PZWebManager

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

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	// self.products = response.products;
 
	for(NSString *invalidIdentifier in response.invalidProductIdentifiers)
    {
		// Handle any invalid product identifiers.
	}
}

@end