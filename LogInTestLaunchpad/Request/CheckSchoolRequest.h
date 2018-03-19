//
//  CheckSchoolRequest.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 28/02/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "BaseRequest.h"

@interface CheckSchoolRequest : BaseRequest
+ (instancetype)requestWithSchoolCode:(NSString *)schoolCode;

@property (strong, nonatomic) NSString *schoolCode;
@end
