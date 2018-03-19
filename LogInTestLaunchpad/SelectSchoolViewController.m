//
//  SelectSchoolViewController.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 08/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "SelectSchoolViewController.h"
#import "SelectSchoolTableViewCell.h"
#import "SelectSchoolRequest.h"
#import "SchoolDetails.h"
#import "SchoolDetailsViewController.h"

@interface SelectSchoolViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectSchoolTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *searchBarContainer;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *schoolsTableView;
@property (strong, nonatomic) NSMutableArray *schoolsTableViewData;
@property (strong, nonatomic) NSMutableArray *searchedData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarContainerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schoolsTableViewTopConstraint;

/// boolean for marking the search action, for changing the data source
@property BOOL isSearching;
@property NSInteger oldSearchBarContainerTopConstraintConstant;
/// boolean for marking if the animation was done through the top direction
/// used for taking immediate action, not only if the animation was finished, when scrolling in positive offset
/// the impact being the resigning the first responder and animating Down the Label
@property BOOL isAnimatedTop;
/// boolean used for scrolling in negative offset, to mark if the animatios has finished, if yes, will resign the first responder
/// isAnimatedTop wasn't enough beacause it was used for other logic, when animation was still in progress
/// because of the 0.5 seconds of the animation, we want to let the negative offset scrolling to have impact only if the animation finished succesfully
/// the impact being the resigning the first responder and animating Down the Label
/// Practically you can scroll in negative offset and it can have an impact to the view, if the animation finished
@property BOOL animationFinishedTop;
@end

@implementation SelectSchoolViewController

#pragma mark - lazy initializations

- (NSMutableArray *)schoolsTableViewData {
    if(!_schoolsTableViewData) {
        _schoolsTableViewData = [NSMutableArray new];
    }
    return _schoolsTableViewData;
}

- (NSMutableArray *)searchedData {
    if(!_searchedData) {
        _searchedData = [NSMutableArray new];
    }
    return _searchedData;
}

#pragma mark - viewcontroller lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTableViewCell];
    [self initializeTableView];
    self.searchBarContainer.layer.cornerRadius = self.searchBarContainer.frame.size.height/2;
    self.isSearching = NO;
    self.isAnimatedTop = NO;
    self.animationFinishedTop = NO;

    self.schoolsTableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.schoolsTableView.delegate = self;
    self.schoolsTableView.dataSource = self;
    self.searchTextField.delegate = self;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSNumber *valueLeft = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:valueLeft forKey:@"orientation"];
        NSNumber *valueRight = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:valueRight forKey:@"orientation"];
    }
    [self.schoolsTableView reloadData];
    [self loadData];
}

#pragma mark - initializations

- (void)initializeTableViewCell {
    UINib *nib = [UINib nibWithNibName:@"SelectSchoolTableViewCell" bundle:nil];
    [self.schoolsTableView registerNib:nib forCellReuseIdentifier:@"SelectSchoolTableViewCell"];
}

- (void)initializeTableView {
    self.schoolsTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.schoolsTableView flashScrollIndicators];
}

#pragma mark - Utils

/**
 Used for creating an object from a dictionary
 @param dictionary input dictionary
 @return the new object created
 */
- (SchoolDetails *)createSchoolDetailsFromDictionary:(NSDictionary *)dictionary {
    SchoolDetails *schoolDetails = [SchoolDetails new];
    schoolDetails.schoolDistrict = dictionary[@"district"];
    schoolDetails.logoUrl = dictionary[@"logo_url"];
    schoolDetails.schoolState = dictionary[@"state"];
    schoolDetails.settingsCode = dictionary[@"settings_code"];
    
    return schoolDetails;
}


/**
 Sorting by a property
 @param data data to be sorted
 @param keyForSorting the property for sorting
 @return sorted array
 */
- (NSMutableArray *)sort:(NSMutableArray *)data by:(NSString *)keyForSorting{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyForSorting
                                                 ascending:YES];
    NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithArray:[data sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
    return sortedArray;
}

#pragma mark - request for loading the data

- (void)loadData {
    SelectSchoolRequest *request = [SelectSchoolRequest new];
    
    [request setSuccess:^(NSURLSessionDataTask *request, id response) {
        NSMutableArray *items;
        items = [[NSMutableArray alloc] initWithArray:[response allValues]];
        
        SchoolDetails *classLinkLaunchpadDetails;
        for (NSDictionary *item in items) {
            if([item[@"ios_enabled"] boolValue] == YES) {
                ///for placing the ClassLink first in the list
                if([item[@"district"] isEqualToString:@"ClassLink Launchpad"]) {
                    classLinkLaunchpadDetails = [self createSchoolDetailsFromDictionary:item];
                } else {
                    [self.schoolsTableViewData addObject:[self createSchoolDetailsFromDictionary:item]];
                }
            }
        }
        self.schoolsTableViewData = [self sort:self.schoolsTableViewData by:@"schoolDistrict"];
        if(classLinkLaunchpadDetails) {
            [self.schoolsTableViewData insertObject:classLinkLaunchpadDetails atIndex:0];
        }
        
        [self.schoolsTableView reloadData];
    }];
    
    [request setError:^(NSURLSessionDataTask *request, NSError *error) {
        
    }];
    
    [request runRequest];
}

#pragma mark - search bar actions

- (IBAction)typingText:(UITextField *)sender {
    [self searchByThisString:sender.text];
}
- (IBAction)editingEnd:(id)sender {
        [self animateTitleLabel:NO andWithLabelHidden:NO];
}

#pragma mark - tableview delegates and tableViewDataSource delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 120.0;
    } else {
        return 80.0;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SelectSchoolTableViewCell *cell = [self.schoolsTableView dequeueReusableCellWithIdentifier:@"SelectSchoolTableViewCell"];
    
    if (self.isSearching) {
        if ([self.searchedData count] > 0) {
        SchoolDetails *schoolDetail = (SchoolDetails *)self.searchedData[indexPath.row];
        [cell populateWith:schoolDetail.schoolDistrict andState:schoolDetail.schoolState andLogoUrlString:schoolDetail.logoUrl];
        }
    } else {
        SchoolDetails *schoolDetail = (SchoolDetails *)self.schoolsTableViewData[indexPath.row];
        [cell populateWith:schoolDetail.schoolDistrict andState:schoolDetail.schoolState andLogoUrlString:schoolDetail.logoUrl];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolDetails *schoolDetail;
    
    if (self.isSearching) {
        if ([self.searchedData count] > 0) {
            schoolDetail = (SchoolDetails *)self.searchedData[indexPath.row];
        }
    } else {
        schoolDetail = (SchoolDetails *)self.schoolsTableViewData[indexPath.row];
    }

    SchoolDetailsViewController *svc = [SchoolDetailsViewController new];
    svc.schoolDetails = schoolDetail;
    svc.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return [self.searchedData count];
    }
    return [self.schoolsTableViewData count];
}

#pragma mark - search pattern

- (void)searchByThisString:(NSString *)searchingText {
    if(searchingText.length > 0 && ![searchingText isEqualToString:@" "]) {
        self.isSearching = YES;
        self.searchedData = [self searchDistrict:searchingText];
        [self.schoolsTableView reloadData];
    } else if ([searchingText isEqualToString:@""]) {
        self.isSearching = NO;
        [self.schoolsTableView reloadData];
    }
}

- (NSMutableArray *)searchDistrict:(NSString *)districtName {
    NSMutableArray *searchingResult = [NSMutableArray new];
    
    for (SchoolDetails *details in self.schoolsTableViewData) {
        if ([[details.schoolDistrict lowercaseString] containsString:[districtName lowercaseString]]) {
            [searchingResult addObject:details];
        }
    }
    
    return searchingResult;
}

#pragma mark - animations

/**
 Used for animating the view when typing in the search bar.
 It hides the title label and moves the tableview and the search bar by the top constraints, doubling the value

 @param toTop boolean for specifying the direction of the animation
 @param isHidden boolean for specifying if to hide the title label or not
 */
- (void)animateTitleLabel:(BOOL)toTop andWithLabelHidden:(BOOL)isHidden{
    self.isAnimatedTop = YES;
    [UIView animateWithDuration:0.5 animations:^{
        if (isHidden) {
            [self.selectSchoolTitleLabel setHidden:isHidden];
        }
        if(toTop) {
            self.oldSearchBarContainerTopConstraintConstant = self.searchBarContainerTopConstraint.constant;
            self.searchBarContainerTopConstraint.constant = self.searchBarContainerTopConstraint.constant - 2 * self.oldSearchBarContainerTopConstraintConstant;
            self.schoolsTableViewTopConstraint.constant = self.schoolsTableViewTopConstraint.constant - 2 * self.oldSearchBarContainerTopConstraintConstant;
        } else {
            self.searchBarContainerTopConstraint.constant = self.searchBarContainerTopConstraint.constant + 2 * self.oldSearchBarContainerTopConstraintConstant;
            self.schoolsTableViewTopConstraint.constant = self.schoolsTableViewTopConstraint.constant + 2 * self.oldSearchBarContainerTopConstraintConstant;
            self.isAnimatedTop = NO;
        }
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (!isHidden) {
            [self.selectSchoolTitleLabel setHidden:isHidden];
        }
        if(toTop) {
            self.animationFinishedTop = YES;
        } else {
            self.animationFinishedTop = NO;
        }
    }];
    
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTitleLabel:YES andWithLabelHidden:YES];
    [self.schoolsTableView setContentOffset:self.schoolsTableView.contentOffset animated:NO];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0 ) {
        if(self.animationFinishedTop) {
            if([self.searchTextField isFirstResponder]) {
                [self.searchTextField resignFirstResponder];
            }
        }
        return;
    } else {
        [self.searchTextField resignFirstResponder];
        if(self.isAnimatedTop) {
            [self animateTitleLabel:NO andWithLabelHidden:NO];
        }
    }

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"schoolDetail"]) {
        SchoolDetails *schoolDetails = (SchoolDetails *)sender;
        SchoolDetailsViewController *sdvc = [segue destinationViewController];
        sdvc.schoolDetails = schoolDetails;
    }
}


@end
