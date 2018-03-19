//
//  Created by Silviu Pop on 3/12/13.
//  Copyright (c) 2013 Whatevra. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

static NSString * const SERVER_BASE_URL = @"https://api.classlink.com/";
static NSString * const NODE_SERVER_BASE_URL = @"https://nodeapi.classlink.com/";
static NSString * const APINET_SERVER_BASE_URL = @"https://apinet.classlink.com"; // required without terminating '/' character

static NSString * const STAGING_NODE_SERVER_BASE_URL = @"https://stagingnodeapi.classlink.com/";

static NSString * const ClasslinkAPIKey = @"xxx-xxx-xxx";

typedef enum {
    kRequestMethodGET,
    kRequestMethodPOST,
    kRequestMethodPUT,
    kRequestMethodDELETE
} RequestMethod;

@class BaseRequest;

typedef void(^RequestSuccessBlock)(NSURLSessionDataTask *request, id response);
typedef void(^RequestErrorBlock)(NSURLSessionDataTask *request, NSError *error);
typedef void(^RequestExceptionBlock)(id request, NSException *exceptionBlock);

@interface BaseRequest : NSObject

@property BOOL showsProgressIndicator;
@property (strong, nonatomic) NSString *progressIndicatorTitle;

@property (nonatomic, copy) RequestSuccessBlock success;
@property (nonatomic, copy) RequestErrorBlock error;
@property (nonatomic, copy) RequestExceptionBlock exceptionBlock;
@property (strong, nonatomic) AFHTTPSessionManager *requestOperationManager;

+ (instancetype)request;

- (NSString *)serverBase;
- (NSString *)requestURL;
- (NSDictionary *)params;
- (NSDictionary *)defaultHeaders;
- (NSData *)fileData;
- (RequestMethod)requestMethod;
- (id)successData:(id)data;

- (void)runRequest;
- (void)sendRequest:(id)failureBlock successBlock:(id)successBlock path:(NSString *)path;

- (void)setSuccess:(RequestSuccessBlock)success;
- (void)setError:(RequestErrorBlock)error;
- (void)setExceptionBlock:(RequestExceptionBlock)exceptionBlock;
- (void)handleException:(NSException *)exception;

- (BOOL)shouldReturnAfterDefaultErrorHandling:(NSError *)error;
- (BOOL)getDataFromXML;
- (BOOL)getResponseData;
- (void)addHeaders;

- (NSString *)encodeString:(NSString *)text;

- (BOOL)shouldUseRequestJSONSerializer;

@end
