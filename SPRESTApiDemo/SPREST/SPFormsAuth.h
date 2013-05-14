//
//  SPFormsAuth.h
//  HelloWorld
//
//  Created by James Love on 10/05/2013.
//
//

#import <Foundation/Foundation.h>

@class SPAuthentication;
@protocol   SPAuthenticationDelegate <NSObject>
@optional
- (void)authentication: (SPAuthentication *)didAuthenticate;
- (void)authentication: (SPAuthentication *)didFailWithError: (NSError *)error;
@end

@interface SPFormsAuth : NSObject
{
    id<SPAuthenticationDelegate> authDelegate;
}

@property (nonatomic, retain) NSMutableData *tokenResponse;
@property (nonatomic, retain) NSString *soapTemplate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *siteUrl;
@property (nonatomic, retain) id <SPAuthenticationDelegate> authDelegate;


-(id)initWithUsernamePasswordSite: (NSString *)uname password:(NSString *)pword site:(NSString *)site;
-(void) authenticate;

@end
