//
//  WSReplyDelegate.h
//  SimpleSharePointTest
//
//  Created by James Love on 11/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WSReplyDelegate : NSObject
{

}

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSObject *initiatingObject;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSString *siteUrl;

@end
