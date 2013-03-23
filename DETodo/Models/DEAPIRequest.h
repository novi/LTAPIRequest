//
//  DEAPIRequest.h
//  DETodo
//
//  Created by ito on 2013/03/21.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTAPIRequest.h"

@class DEAPIResponse;
typedef void(^DEAPIRequestCallback)(DEAPIResponse* res);

@interface DEAPIRequest : LTAPIRequest

-(void)sendRequestWithCallback:(DEAPIRequestCallback)callback;

@end
