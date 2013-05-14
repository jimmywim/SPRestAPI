//
//  SPRESTListItem.h
//  SPRESTApiDemo
//
//  Created by James Love on 16/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRESTListItem : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *itemGuid;
@property (nonatomic, retain) NSString *contentTypeId;
@property int itemId;
@end
