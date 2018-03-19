//
//  SelectSchoolTableViewCell.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 08/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSchoolTableViewCell : UITableViewCell
- (void)populateWith:(NSString *)district andState:(NSString *)state andLogoUrlString:(NSString *)logoUrlString;
@end
