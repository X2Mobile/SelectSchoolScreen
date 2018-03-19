//
//  LoginRequest.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 28/02/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "BaseRequest.h"


@interface LoginRequest : BaseRequest
- (id)initWithUsername:(NSString *)username withPassword:(NSString *)password;
+ (instancetype)createWithUsername:(NSString *)username withPassword:(NSString *)password withSchoolCode:(NSString *)schoolcode andDomainName:(NSString *)domainName;
@end
