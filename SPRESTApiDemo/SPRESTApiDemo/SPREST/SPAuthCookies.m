//
//  SPAuthCookies.m
//  SimpleSharePointTest
//
//  Created by James Love on 11/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "SPAuthCookies.h"

@implementation SPAuthCookies

@synthesize fedAuth;
@synthesize rtFa;
@synthesize siteUrl;

static SPAuthCookies *SharedSPAuthCookie;

+ (SPAuthCookies *)sharedSPAuthCookie
{
    @synchronized([SPAuthCookies class])
	{
		if (!SharedSPAuthCookie)
			(void)[[self alloc] init];
        
		return SharedSPAuthCookie;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([SPAuthCookies class])
	{
		NSAssert(SharedSPAuthCookie == nil, @"Attempted to allocate a second instance of a singleton.");
		SharedSPAuthCookie = [super alloc];
		return SharedSPAuthCookie;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

+(NSMutableArray *)getSharedAuthCookies:(NSURL *)apiUri
{
    NSDictionary *fedAuthCookie = [NSDictionary dictionaryWithObjectsAndKeys:
                                   apiUri, NSHTTPCookieOriginURL,
                                   @"FedAuth", NSHTTPCookieName,
                                   @"/", NSHTTPCookiePath,
                                   [[SPAuthCookies sharedSPAuthCookie] fedAuth] , NSHTTPCookieValue,
                                   nil];
    
    NSDictionary *rtFaCookie = [NSDictionary dictionaryWithObjectsAndKeys:
                                apiUri, NSHTTPCookieOriginURL,
                                @"rtFa", NSHTTPCookieName,
                                @"/", NSHTTPCookiePath,
                                [[SPAuthCookies sharedSPAuthCookie] rtFa] , NSHTTPCookieValue,
                                nil];
    
    
    NSHTTPCookie *fedAuthCookieObj = [NSHTTPCookie cookieWithProperties:fedAuthCookie];
    NSHTTPCookie *rtFaCookieObj = [NSHTTPCookie cookieWithProperties:rtFaCookie];
    
    NSMutableArray *cookiesArray = [NSMutableArray arrayWithObjects:rtFaCookieObj, nil];
    [cookiesArray addObject:fedAuthCookieObj];
    
    return cookiesArray;
}


@end
