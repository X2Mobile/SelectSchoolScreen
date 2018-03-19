//  Created by Silviu Pop on 3/12/13.
//  Copyright (c) 2013 Whatevra. All rights reserved.
//

#import "BaseRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NSObject+AlertUtils.h"

@implementation BaseRequest

- (id)init {
    self = [super init];
    if (self != nil) {
        self.showsProgressIndicator = YES;
    }
    return self;
}

+ (instancetype)request {
    return [self new];
}

- (NSString *)serverBase {
    return NODE_SERVER_BASE_URL;
//    return STAGING_NODE_SERVER_BASE_URL;
}

- (NSString *)requestURL {
    return @"";
}

- (NSDictionary *)params {
    return @{
             };
}

- (NSDictionary *)defaultHeaders {
    return @{
             };
}

- (NSData *)fileData {
    return nil;
}

- (RequestMethod)requestMethod {
    return kRequestMethodGET;
}

// Required For Autocomplete

- (void)setSuccess:(RequestSuccessBlock)success {
    _success = success;
}

- (void)setError:(RequestErrorBlock)error {
    _error = error;
}

- (void)setExceptionBlock:(RequestExceptionBlock)exceptionBlock {
    _exceptionBlock = exceptionBlock;
}

- (void)handleException:(NSException *)exception {
    if (self.exceptionBlock) {
        self.exceptionBlock(self,exception);
    }
}

- (BOOL)getDataFromXML {
    return NO;
}

- (BOOL)getResponseData {
    return NO;
}

- (id)successData:(id)data {
    return data;
}

- (void)sendRequest:(id)failureBlock successBlock:(id)successBlock path:(NSString *)path {
    switch ([self requestMethod]) {
        case kRequestMethodGET:
            [self.requestOperationManager GET:path
                                   parameters:[self params]
                                     progress:nil
                                      success:successBlock
                                      failure:failureBlock];
            break;
        case kRequestMethodPOST:
            if ([self fileData]) {
                [self.requestOperationManager POST:path
                                        parameters:[self params]
                         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                             [formData appendPartWithFileData:[self fileData]
                                                         name:@""
                                                     fileName:@""
                                                     mimeType:@""];
                         }
                                          progress:nil
                                           success:successBlock
                                           failure:failureBlock];
            } else {
                [self.requestOperationManager POST:path
                                        parameters:[self params]
                                          progress:nil
                                           success:successBlock
                                           failure:failureBlock];
            }
            break;
        case kRequestMethodPUT:
            [self.requestOperationManager PUT:path parameters:[self params] success:successBlock failure:failureBlock];
            break;
        case kRequestMethodDELETE:
            [self.requestOperationManager DELETE:path parameters:[self params] success:successBlock failure:failureBlock];
            break;
    }
}

- (BOOL)shouldReturnAfterDefaultErrorHandling:(NSError *)error {
    switch (error.code) {
        case -1009: {
            dispatch_async(dispatch_get_main_queue(), ^{
             
            });
            return YES;
        }
    }
    
    // Handling GWSToken expiration
    NSHTTPURLResponse *urlResponseError = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    NSInteger statusCode = urlResponseError.statusCode;
    
    if (statusCode == 401) {
      
        return YES;
    }

    return NO;
}

- (void)addHeaders {
    for (NSString *key in self.defaultHeaders.allKeys) {
        [self.requestOperationManager.requestSerializer setValue:self.defaultHeaders[key] forHTTPHeaderField:key];
    }
}

- (BOOL)shouldUseRequestJSONSerializer {
    return NO;
}

- (void)runRequest {
    self.requestOperationManager = [AFHTTPSessionManager new];
    self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([self shouldUseRequestJSONSerializer]) {
        self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
   //[self.requestOperationManager.requestSerializer setValue:[DataManager shared].GWSToken forHTTPHeaderField:@"gwstoken"];
    [self addHeaders];
    
    NSString *path = [[self serverBase] stringByAppendingString:[self requestURL]];
    NSLog(@"### PATH %@", path);
    
    if (self.showsProgressIndicator) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *window = [[[UIApplication sharedApplication] delegate] window];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
        });
    }
    
    __weak BaseRequest *_self = self;
    
    id successBlock = ^(NSURLSessionDataTask *task, id response){
        @try {

            if (_self.showsProgressIndicator) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *window = [[[UIApplication sharedApplication] delegate] window];
                    [MBProgressHUD hideHUDForView:window animated:YES];
                });
            }
            
            id data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if ([self getDataFromXML]) {
               // data = [NSDictionary dictionaryWithXMLData:response];
            }
            
            if ([self getResponseData]) {
                data = response;
            }
            
            if (_self.success) {
                _self.success(task, [_self successData:data]);
            }
        }
        @catch (NSException *exception) {
//            PO(exception)
            [self handleException:exception];
        }
    };
    
    id failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        @try {
            if (_self.showsProgressIndicator) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *window = [[[UIApplication sharedApplication] delegate] window];
                    [MBProgressHUD hideHUDForView:window animated:YES];
                });
            }
            
            if (error.code == 401) {
                NSLog(@"%@", error.localizedDescription);
            }
            
            if ([_self shouldReturnAfterDefaultErrorHandling:error]) {
                return;
            }
            
            if (_self.error) {
                _self.error(task, error);
                
            }
        }
        @catch (NSException *exception) {
//            NSLog(@"%@", exception);
            [self handleException:exception];
        }
        
    };

    [self sendRequest:failureBlock successBlock:successBlock path:path];
}


- (NSString *)encodeString:(NSString *)text {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                     NULL,
                                                                     (__bridge CFStringRef)text,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8));
}

@end
