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
@property (nonatomic, readonly) NSURL *fullQueryUri;
@property (nonatomic, retain) NSString *requestId;

-(id)initWithUrl:(NSString *)url;
-(id)initWithUrlRequestId:(NSString *)url id:(NSString *)requestId;
-(void)executeQuery;
-(void) returnValue:(NSData *)returnedData;
@end

@protocol SPRESTDelegate <NSObject>
@optional
-(void)SPREST:(id)SPREST didCompleteQuery: (SMXMLDocument *)result;
-(void)SPREST:(id)SPREST didCompleteQueryWithRequestId: (SMXMLDocument *)result requestId:(NSString *)requestId;
-(void)SPREST:(id)SPREST didCompleteWithFailure: (NSError *)error;
@end
