//
//  SPClaimsHelper.h
//  SimpleSharePointTest
//
//  Created by James Love on 09/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSReplyDelegate.h"

@class SPClaimsToken;
@protocol   SPClaimsTokenDelegate <NSObject>
@optional
- (void)tokenDelegate: (SPClaimsToken *)tokenClass didReceiveToken: (int)count;

@end



@interface SPClaimsHelper : NSObject
{
    id <SPClaimsTokenDelegate> delegate;
}

@property (nonatomic, retain) NSMutableData *tokenResponse;
@property (nonatomic, retain) id <SPClaimsTokenDelegate> delegate;
@property (nonatomic, readonly) WSReplyDelegate *wsReply;
@property (nonatomic, retain) NSString *soapTemplate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *siteUrl;



-(id)initWithUsernamePasswordSite: (NSString *)uname password:(NSString *)pword site:(NSString *)site;
-(void) GetTokens;
-(void)tokensReady: (int)cookieCount;
-(NSString *)hasError;
@end
