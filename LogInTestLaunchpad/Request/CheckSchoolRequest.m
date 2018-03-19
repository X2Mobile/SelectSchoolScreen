//
//  CheckSchoolRequest.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 28/02/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "CheckSchoolRequest.h"

@implementation CheckSchoolRequest

+ (instancetype)requestWithSchoolCode:(NSString *)schoolCode {
    CheckSchoolRequest *request = [self new];
    request.schoolCode = schoolCode;
    return request;
}

- (NSString *)serverBase {
    return SERVER_BASE_URL;
}

- (NSString *)requestURL {
    NSString *safeSchoolCode = [self.schoolCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"auth/schoolcode/%@",safeSchoolCode];
}

@end
