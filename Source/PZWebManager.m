//
//  PZWebManager.m
//  bacterial
//
//  Created by 李翌文 on 14-7-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "PZWebManager.h"

@implementation PZWebManager
{
    NSMutableData *receiveData;
}

static PZWebManager *_sharedPZWebManager = nil;

+(PZWebManager *)sharedPZWebManager
{
    if(!_sharedPZWebManager)
    {
        _sharedPZWebManager = [[PZWebManager alloc] init];
    }
    return _sharedPZWebManager;
}

-(NSURLConnection *)asyncGetRequest:(NSString *)url withData:(NSDictionary *)data
{
    NSURL *u = [NSURL URLWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:u cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    return connection;
}

-(NSURLConnection *)asyncPostRequest:(NSString *)url withData:(NSDictionary *)data
{
    NSURL *u = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:u cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    
    if(data != nil)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        [request setHTTPBody:postData];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    return connection;
}

#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:&error];
    NSString *command = [data objectForKey:@"command"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:command object:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

@end
