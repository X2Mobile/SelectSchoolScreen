//
//  GetUserDomainListRequest.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 01/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "BaseRequest.h"

@interface GetUserDomainListRequest : BaseRequest

+ (instancetype)requestWithUsername:(NSString *)username schoolCode:(NSString *)schoolCode;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *schoolCode;
@end
