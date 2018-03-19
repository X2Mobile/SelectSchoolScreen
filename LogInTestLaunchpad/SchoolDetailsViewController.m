///Users/mirceadragota/Documents/Developer/ObjC/LogInTestLaunchpad/LogInTestLaunchpad/SchoolDetailsViewController.m
//  SchoolDetailsViewController.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 15/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "SchoolDetailsViewController.h"

@interface SchoolDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@end

@implementation SchoolDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.detailsTextView.text = self.schoolDetails.description;
}


@end
