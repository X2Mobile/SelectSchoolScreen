//
//  SelectSchoolTableViewCell.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 08/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "SelectSchoolTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SelectSchoolTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation SelectSchoolTableViewCell



- (void)populateWith:(NSString *)district andState:(NSString *)state andLogoUrlString:(NSString *)logoUrlString {
    self.districtLabel.text = district;
    self.stateLabel.text = state;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrlString]
                          placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
}

@end
