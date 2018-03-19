//
//  LoginRequest.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 28/02/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "LoginRequest.h"
#import "NSObject+AlertUtils.h"
@interface LoginRequest()
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *schoolcode;
@property (strong, nonatomic) NSString *domainName;
@end
@implementation LoginRequest

//doar asa
- (id)initWithUsername:(NSString *)username withPassword:(NSString *)password {
    if (self = [super init]) {
        self.username = username;
        self.password = password;
    }
    return self;
}

+ (instancetype)createWithUsername:(NSString *)username withPassword:(NSString *)password withSchoolCode:(NSString *)schoolcode andDomainName:(NSString *)domainName {
    LoginRequest *request = [[LoginRequest alloc] init];
    request.username = username;
    request.password = password;
    request.schoolcode = schoolcode;
    request.domainName = domainName;
    return request;
}

- (NSString *)serverBase {
    return SERVER_BASE_URL;
}

- (RequestMethod)requestMethod {
    return kRequestMethodPOST;
}

- (NSString *)requestURL {
    return @"auth";
}

- (NSDictionary *)params {
    return @{
             @"password": self.password,
             @"code": self.schoolcode,
             @"username": self.username,
             @"userdn": self.domainName
             };
}

- (NSDictionary *)defaultHeaders {
    return @{
             @"username": self.username,
             @"code": self.schoolcode
             };
}
@end
