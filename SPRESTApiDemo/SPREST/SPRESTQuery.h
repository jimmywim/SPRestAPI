//
//  SPRESTQuery.h
//  SimpleSharePointTest
//
//  Created by James Love on 12/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
@protocol SPRESTDelegate;



@interface SPRESTQuery : NSObject
@property (nonatomic, weak) id <SPRESTDelegate> delegate;
@property (nonatomic, retain) NSString *queryUrl;
@property (nonatomic, retain) NSURL *fullQueryUri;
@property (nonatomic, retain) NSString *requestId;
@property (nonatomic, retain) NSString *requestMethod;
@property (nonatomic, retain) NSData *attachedFile;
@property (nonatomic, retain) NSString *payload;
@property (nonatomic, retain) NSString *soapAction;

@property BOOL includeFormDigest;

-(id)initWithUrl:(NSString *)url;
-(id)initWithUrlRequestId:(NSString *)url id:(NSString *)requestId;
-(void)executeQuery;
-(void) returnValue:(NSData *)returnedData statusCode:(NSInteger) statusCode;
-(void) returnedBadError:(NSError* )error;
@end

@protocol SPRESTDelegate <NSObject>
@optional
-(void)SPREST:(id)SPREST didCompleteQuery: (SMXMLDocument *)result;
-(void)SPREST:(id)SPREST didCompleteQueryWithRequestId: (SMXMLDocument *)result requestId:(NSString *)requestId;
-(void)SPREST:(id)SPREST didCompleteWithFailure: (NSError *)error;
-(void)SPREST:(id)SPREST didCompleteWithAuthFailure: (NSError *)error;
@end
