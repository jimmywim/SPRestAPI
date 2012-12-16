//
//  SPRequestDigest.m
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "SPRequestDigest.h"
#import "SPRESTQuery.h"

@implementation SPRequestDigest

@synthesize formDigest = _formDigest;
@synthesize siteUrl = _siteUrl;
@synthesize digestExpiry = _digestExpiry;

static SPRequestDigest *SharedSPRequestDigest;

+ (SPRequestDigest *)sharedSPRequestDigest
{
    @synchronized(self)
	{
		if (!SharedSPRequestDigest)
			(void)[[self alloc] init];
        
		return SharedSPRequestDigest;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([SPRequestDigest class])
	{
		NSAssert(SharedSPRequestDigest == nil, @"Attempted to allocate a second instance of a singleton.");
		SharedSPRequestDigest = [super alloc];
		return SharedSPRequestDigest;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        self.digestExpiry = [NSDate date];
    }
    
	return self;
}

+(NSString *)getFormDigest
{
    [SPRequestDigest ValidateRequestDigest];
    return [[SPRequestDigest sharedSPRequestDigest] formDigest];
}

+(void)ValidateRequestDigest
{
    NSDate *dateNow = [NSDate date];
    SPRequestDigest *digest = [SPRequestDigest sharedSPRequestDigest];
    
    NSDate *expDate = digest.digestExpiry;
    
    if([dateNow compare:expDate] == NSOrderedDescending)
    {
        // digest has expired
        [[SPRequestDigest sharedSPRequestDigest] GetNewRequestDigest];
    }
}

-(void)GetNewRequestDigest
{
    // This NEEDS to happen synchronously. If we try to get this synchronously, other requests
    // will try to kick off with the digest unset, repeatedly requesting more digests unnecessary.
    
    NSMutableString *contextInfoUrl = [[NSMutableString alloc] initWithString:self.siteUrl];
    [contextInfoUrl appendString:@"/_api/contextinfo"];
    
    NSURL *url = [[NSURL alloc] initWithString:contextInfoUrl];
    NSMutableURLRequest *apiRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [apiRequest setValue:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"  forHTTPHeaderField:@"User-Agent"];
    [apiRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [apiRequest setHTTPMethod:@"POST"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:apiRequest  returningResponse:&response error:&error];

    
    NSLog(@"String sent from server %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

    
    SMXMLDocument *document = [SMXMLDocument documentWithData:responseData error:&error];
    
    SMXMLElement *bodyElement = document.root;
    [[SPRequestDigest sharedSPRequestDigest] setFormDigest:[bodyElement valueWithPath:@"FormDigestValue"]];
    
    int expiresAfterSeconds = [[bodyElement valueWithPath:@"FormDigestTimeoutSeconds"] intValue];
    SPRequestDigest *digest = [SPRequestDigest sharedSPRequestDigest];
    digest.digestExpiry = [[NSDate date] dateByAddingTimeInterval:expiresAfterSeconds];
    
    NSLog(@"Got digest");
}


@end
