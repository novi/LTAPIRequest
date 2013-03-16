//
//  Request.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "APIRequest.h"
#import "User.h"
#import "APIResponse.h"

@interface APIRequest ()
{

}
@end

@implementation APIRequest


-(NSMutableURLRequest *)prepareRequest
{
    SLRequestMethod method;
    if (self.method == LTAPIRequestMethodGET) {
        method = SLRequestMethodGET;
    }
    
    SLRequest* req = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:method URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1%@.json", self.path]] parameters:self.params];
    req.account = [User me].account;
    
    NSMutableURLRequest* reqs = [[req preparedURLRequest] mutableCopy];
    NSLog(@"%@: %@", reqs, reqs.URL);
    return reqs;
}

+(Class)APIResponseClass
{
    return [APIResponse class];
}


#pragma mark -

+(ACAccountStore *)accountStore
{
    static ACAccountStore* store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[ACAccountStore alloc] init];
    });
    return store;
}

@end
