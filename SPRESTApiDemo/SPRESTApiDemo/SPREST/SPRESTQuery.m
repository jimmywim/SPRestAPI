//
//  SPRESTQuery.m
//  SimpleSharePointTest
//
//  Created by James Love on 12/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "SPRESTQuery.h"
#import "SPAuthCookies.h"
#import "SPAPIResponseHandler.h"
#import "SMXMLDocument.h"
#import "SPRequestDigest.h"

@implementation SPRESTQuery
@synthesize delegate;
@synthesize queryUrl;
@synthesize fullQueryUri;
@synthesize requestId = _requestId;
@synthesize includeFormDigest;
@synthesize requestMethod;

-(id) initWithUrl:(NSString *)url
{
    if (self = [super init])
    {
        queryUrl = url;
        fullQueryUri = [NSURL URLWithString:queryUrl];
        includeFormDigest = YES;
        requestMethod = @"GET";
    }
    
    return self;
}

-(id)initWithUrlRequestId:(NSString *)url id:(NSString *)requestId
{
    if (self = [self initWithUrl:url])
    {
        _requestId = requestId;
    }
    
    return self;
}

-(void)executeQuery
{
    NSMutableURLRequest *apiRequest = [[NSMutableURLRequest alloc] initWithURL:fullQueryUri];
    [apiRequest setValue:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"  forHTTPHeaderField:@"User-Agent"];
    [apiRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [apiRequest setValue:@"ISO-8859-1,utf-8;q=0.7,*;q=0.3" forHTTPHeaderField:@"Accept-Charset"];
    [apiRequest setValue:requestMethod forHTTPHeaderField:@"METHOD"];
    [apiRequest setHTTPMethod:requestMethod];
    
    if (includeFormDigest)
    {
        [SPRequestDigest ValidateRequestDigest];
        [apiRequest setValue:[[SPRequestDigest sharedSPRequestDigest] formDigest] forHTTPHeaderField:@"X-RequestDigest"];
    }
    
    NSMutableArray *cookiesArray = [SPAuthCookies getSharedAuthCookies:fullQueryUri];
                                    
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookiesArray];
    [apiRequest setAllHTTPHeaderFields:headers];
    SPAPIResponseHandler *apiHandler = [[SPAPIResponseHandler alloc] init];
    apiHandler.targetObject = self;
    
    (void)[[NSURLConnection alloc] initWithRequest:apiRequest delegate:apiHandler];
}


-(void) returnValue:(NSData *)returnedData
{
    // Load the returned string into XML and pass it to this instance's delegate for the
    // client app to consume
    //NSString* newStr = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    //NSLog(@"Returned Data:%@", newStr);
    NSError *error;
    SMXMLDocument *document = [SMXMLDocument documentWithData:returnedData error:&error];
    
    if ([_requestId length] == 0)
    {
        [delegate SPREST:self didCompleteQuery:document];
    }
    else
    {
        [delegate SPREST:self didCompleteQueryWithRequestId:document requestId:_requestId];
    }
}
@end
