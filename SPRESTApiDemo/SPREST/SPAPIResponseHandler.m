//
//  SPAPIResponseHandler.m
//  SimpleSharePointTest
//
//  Created by James Love on 11/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "SPAPIResponseHandler.h"
#import "SPRESTQuery.h"

@implementation SPAPIResponseHandler
@synthesize responseData = _responseData;
@synthesize targetObject;

-(id) init
{
    if (self = [super init])
    {
        _responseData = [NSMutableData alloc];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    //NSLog(@"Response Status: %d", [resp statusCode]);

    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    [_responseData appendData:data];
    //[(SPRESTQuery *)targetObject returnValue:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection
{
    //NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@", responseString);
    // For some really f*cking odd reason, this clears the response.
    [(SPRESTQuery *)targetObject returnValue:_responseData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection didFailWithError (connection %p) (code %d) %@ %@ %@",
          connection,
          [error code],
          [error localizedDescription],
          [error localizedFailureReason],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}



@end
