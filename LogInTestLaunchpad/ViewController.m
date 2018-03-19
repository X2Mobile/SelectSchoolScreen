//
//  ViewController.m
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 28/02/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import "ViewController.h"
#import "LoginRequest.h"
#import "CheckSchoolRequest.h"
#import "GetUserDomainListRequest.h"
#import "NSObject+AlertUtils.h"
#import "ClassA.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *schoolcodeTextField;
@property (strong, nonatomic) ClassA *myClass;

@end

@implementation ViewController

- (ClassA *) myClass {
    if(!_myClass) {
        _myClass = [[ClassA alloc] init];
    }
    return _myClass;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.myClass.delegate = self;
  //  [self.myClass basicMethod];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)didTapLogIn:(id)sender {
    NSString *username = [self.usernameTextField text];
    NSString *password = [self.passwordTextField text];
    NSString *code = [self.schoolcodeTextField text];
    
    
 // [self doCheckSchoolRequestWithUsername:username withPassword:password andSchoolCode:code];
    
}

-(void)doCheckSchoolRequestWithUsername:(NSString *)username withPassword:(NSString *)password andSchoolCode:(NSString *)code {
    
    if ([code length] == 0) {
        printf("Please enter the code \n");
    } else {
        
        CheckSchoolRequest *request = [CheckSchoolRequest requestWithSchoolCode:code];
        
        [request setSuccess:^(NSURLSessionDataTask *request, id response) {
            if ([response[@"response"] intValue] == 1) {
                [self getDomainListWithUsername:username withPassword:password andSchoolCode:code];
            } else {
                printf("Invalid School Code");
            }
        }];
        
        [request setError:^(NSURLSessionDataTask *request, NSError *error) {
            
        }];
        
        [request runRequest];
    }
}

-(void)getDomainListWithUsername:(NSString *)username withPassword:(NSString *)password andSchoolCode:(NSString *)code {
    GetUserDomainListRequest *request = [GetUserDomainListRequest requestWithUsername:username schoolCode:code];
    
    [request setSuccess:^(NSURLSessionDataTask *request, id response) {
        if(! [response[@"UserDomainList"] isKindOfClass:[NSNull class]]) {
            NSArray *userDomainList = response[@"UserDomainList"];
            if ([userDomainList count] > 1) {
                //ceva multipleDomainBlock
            }else {
                NSDictionary *domain = userDomainList[0];
               // NSString *string = domain[@"DN"];
                [self doLoginRequestWithUsername:username withPassword:password withSchoolCode:code andDomainName:domain[@"DN"]];
            }
            
        } else {
            printf("Error 1\n");
        }
    }];
    
    [request setError:^(NSURLSessionDataTask *request, NSError *error) {
         printf("Error \n");
    }];
    
    [request runRequest];
}

-(void)doLoginRequestWithUsername:(NSString *)username withPassword:(NSString *)password withSchoolCode:(NSString *) schoolCode andDomainName:(NSString *)domainName{
    LoginRequest *request = [LoginRequest createWithUsername:username withPassword:password withSchoolCode:schoolCode andDomainName:domainName];
    
    [request setSuccess:^(NSURLSessionDataTask *request, id response) {
        [self showAlertWithTitle:@"Logged in" message:@"Welcome" completionHandler:nil];
    }];
    
    [request setError:^(NSURLSessionDataTask *request, NSError *error) {
            
    }];
    
    [request runRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)classDelegateMethod:(ClassA *)sender {
    NSLog(@"apel");
}


@end
