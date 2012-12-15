//
//  SPRequestDigest.h
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRequestDigest : NSObject
@property (nonatomic, retain) NSString *formDigest;
@property (nonatomic, retain) NSString *siteUrl;
@property (nonatomic, retain) NSDate *digestExpiry;

+(SPRequestDigest *)sharedSPRequestDigest;
+(NSString *)getFormDigest;

+(void)ValidateRequestDigest;
@end
