//
//  GetUserDomainListRequest.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 01/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "GetUserDomainListRequest.h"

@implementation GetUserDomainListRequest

+ (instancetype)requestWithUsername:(NSString *)username schoolCode:(NSString *)schoolCode {
    GetUserDomainListRequest *request = [self new];
    
    request.username = username;
    request.schoolCode = schoolCode;
    
    return request;
}

- (NSString *)serverBase {
    return SERVER_BASE_URL;
}

- (NSString *)requestURL {
    return @"auth/userdn";
}

- (NSDictionary *)defaultHeaders {
    return @{@"username":self.username,
             @"code":self.schoolCode};
}

@end
