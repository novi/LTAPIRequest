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

-(void)sendRequestWithCallback:(RequestCallback)callback
{
    [super sendRequestWithCallback:(id)callback];
}

-(NSMutableURLRequest *)prepareRequest
{
    SLRequestMethod method;
    if (self.method == LTAPIRequestMethodGET) {
        method = SLRequestMethodGET;
    } else if (self.method == LTAPIRequestMethodPOST) {
        NSLog(@"not supported yet");
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

-(void)dealloc
{
    NSLog(@"dealloc %@", self);
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


+(void)downloadUserImageWithURL:(NSString*)url callback:(RequestUserImageCallback)callback
{
    url = [url copy];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self lt_sendAsynchronousRequest:req queue:[self imageRequestQueue] completionHandler:^(NSURLResponse * res, NSData * data, NSError * error) {
        if (!data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, url); // failed
            });
            return;
        }
        UIImage* image = [UIImage imageWithData:data];
        if (!image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, url); // failed
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(image, url);
        });
        return;
    }];
}


@end
