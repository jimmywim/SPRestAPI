//
//  SPAPIResponseHandler.h
//  SimpleSharePointTest
//
//  Created by James Love on 11/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAPIResponseHandler : NSObject
@property (nonatomic, strong) NSObject *targetObject;
@property (nonatomic, strong) NSMutableData *responseData;
@property NSInteger responseCode;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection;

@end
