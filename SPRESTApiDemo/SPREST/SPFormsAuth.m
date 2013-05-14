//
//  SPFormsAuth.m
//  HelloWorld
//
//  Created by James Love on 10/05/2013.
//
//

#import "SPFormsAuth.h"
#import "SPREST.h"

@implementation SPFormsAuth

@synthesize tokenResponse;
@synthesize username;
@synthesize password;
@synthesize siteUrl;
@synthesize soapTemplate;
@synthesize authDelegate = _authDelegate;

-(id) init
{
    if (self = [super init])
    {
    }
    
    return self;
}

-(id) initWithUsernamePasswordSite: (NSString *)uname password:(NSString *)pword site:(NSString *)site
{
    if (self = [self init])
    {
        soapTemplate =  @"<?xml version='1.0' encoding='utf-8'?> \
        <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> \
            <soap:Body> \
                <Login xmlns='http://schemas.microsoft.com/sharepoint/soap/'> \
                    <username>%@</username> \
                    <password>%@</password> \
                </Login> \
            </soap:Body> \
        </soap:Envelope>";
        
        username = uname;
        password = pword;
        siteUrl = site;
        
        soapTemplate = [NSString stringWithFormat:soapTemplate, username, password];
    }
    
    return self;
}

- (void) authenticate
{
    tokenResponse = [NSMutableData alloc];
    
    NSMutableString *authUrl = [NSMutableString stringWithString:self.siteUrl];
    [authUrl appendString:@"/_vti_bin/authentication.asmx"];
    
    NSURL *stsUrl = [NSURL URLWithString:authUrl];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:stsUrl];
    [theRequest setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"  forHTTPHeaderField:@"User-Agent"];
    [theRequest setValue:@"http://schemas.microsoft.com/sharepoint/soap/Login" forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setHTTPBody:[soapTemplate dataUsingEncoding:NSUTF8StringEncoding]];
    
    (void)[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection Error: %@", [error description]);
    [_authDelegate authentication:(id)self: error];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response Received");
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSArray *allData = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[NSURL URLWithString:self.siteUrl]];
    
    for(NSHTTPCookie *cookie in allData)
    {
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
    
    [[SPAuthCookies sharedSPAuthCookie] setSiteUrl:siteUrl];
    
    [_authDelegate authentication:(id)self];

}

@end
