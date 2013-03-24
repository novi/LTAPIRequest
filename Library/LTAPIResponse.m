//
//  LTAPIResponse.m
//  LTAPIRequest
//
//  Created by Yusuke Ito on 2013/03/16.
//  Copyright (c) 2013 Yusuke Ito. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "LTAPIResponse.h"

@implementation LTAPIResponse

-(NSError *)parseJSON
{
    NSError* error = nil;
    _json = (id)[NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    return error;
}

-(NSHTTPURLResponse *)HTTPResponse
{
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return (id)self.response;
    }
    return nil;
}

-(BOOL)success
{
    [[NSException exceptionWithName:NSGenericException reason:@"success: should be implemented on subclass" userInfo:nil] raise];
    return NO;
}

-(void)showErrorAlert
{
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%d -> %@ (Error: %@, %@)", self.HTTPResponse.statusCode, self.responseData ? [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] : @"<No Response Data>", self.error.localizedDescription, self.error.localizedFailureReason];
}

@end
