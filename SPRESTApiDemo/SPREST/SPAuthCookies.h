//
//  SPAuthCookies.h
//  SimpleSharePointTest
//
//  Created by James Love on 11/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAuthCookies : NSObject
@property (nonatomic, retain) NSString *fedAuth;
@property (nonatomic, retain) NSString *rtFa;
@property (nonatomic, retain) NSString *siteUrl;

+(SPAuthCookies *)sharedSPAuthCookie;
+(NSMutableArray *)getSharedAuthCookies:(NSURL *)apiUri;
@end
