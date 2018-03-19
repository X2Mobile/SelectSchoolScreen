//
//  SelectSchoolRequest.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 08/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "SelectSchoolRequest.h"

static NSString * const kSelectSchoolBaseURL = @"https://launchpad-169908.firebaseio.com/";

@implementation SelectSchoolRequest

- (NSString *)serverBase {
    return kSelectSchoolBaseURL;
}

- (NSString *)requestURL {
    return @"schools.json";
}

@end
