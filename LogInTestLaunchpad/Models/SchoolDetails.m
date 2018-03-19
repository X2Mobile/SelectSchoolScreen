//
//  SchoolDetails.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 08/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "SchoolDetails.h"

@implementation SchoolDetails

- (NSString *)description {
    return [NSString stringWithFormat: @"SchoolDistrict:%@ \nLogoUrl=%@ \nSchoolState:%@ \nSettingsCode:%@", self.schoolDistrict, self.logoUrl, self.schoolState,self.settingsCode];
}
@end
