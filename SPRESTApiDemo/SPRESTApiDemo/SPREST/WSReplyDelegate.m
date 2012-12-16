//
//  WSReplyDelegate.m
//  SimpleSharePointTest
//
//  Created by James Love on 11/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "WSReplyDelegate.h"
#import "SPAuthCookies.h"
#import "SPClaimsHelper.h"
#import "SMXMLDocument.h"

@implementation WSReplyDelegate
@synthesize responseData = _responseData;
@synthesize initiatingObject;
@synthesize errorMsg;
@synthesize siteUrl;

-(id) init
{
    if (self = [super init])
    {
        _responseData = [NSMutableData alloc];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    
    //NSLog(@"%@", redirectResponse.URL);
    
    // First, we'll check for authentication errors.
    NSString* newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if([newStr rangeOfString:@"Fault"].location != NSNotFound)
    {
        NSError *error;
        NSLog(@"Error logging in");
        SMXMLDocument *responseDoc = [[SMXMLDocument alloc] initWithData:_responseData error:&error];
        
        NSString *errorText = [[[[[[responseDoc.root childNamed:@"Body"] childNamed:@"Fault"] childNamed:@"Detail"] childNamed:@"error"] childNamed:@"internalerror"] valueWithPath:@"text"];
        
        errorMsg = [NSString alloc];
        errorMsg = errorText;
                                      
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)redirectResponse;
    
    NSMutableString *targetSite = [NSMutableString alloc];
    targetSite = [targetSite initWithString:siteUrl];
    [targetSite appendString:@"/_forms/default.aspx?wa=wsignin1.0"];
    
    NSArray *allData = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[NSURL URLWithString:targetSite]];
    
    
    for(NSHTTPCookie *cookie in allData)
    {
        //NSLog(@"Found cookie: %@", cookie.name);
        
        NSString *cookieName = cookie.name;
        
        if([cookieName isEqualToString:@"FedAuth"])
        {
            [[SPAuthCookies sharedSPAuthCookie] setFedAuth:cookie.value];
        }
        else if ([cookieName isEqualToString:@"rtFa"])
        {
            [[SPAuthCookies sharedSPAuthCookie] setRtFa:cookie.value];
        }
    }
    
    return request;
}


- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection
{
    // Lets see if the shared cookie handler has the cookies
    // om nom nom nom
    //
    //NSLog(@"FedAuth: %@", [[SPAuthCookies sharedSPAuthCookie] fedAuth]);
    //NSLog(@"rtFa: %@", [[SPAuthCookies sharedSPAuthCookie] rtFa]);
    
    [(SPClaimsHelper *)initiatingObject tokensReady: 2];
    
}
@end
