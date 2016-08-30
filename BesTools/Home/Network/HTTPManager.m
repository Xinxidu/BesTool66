//
//  HTTPManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <AFHTTPSessionManager.h>

#import "HTTPManager.h"
#import "BaseResponseModel.h"
#import "HTTPErrorCode.h"

#define MAX_CONCURRENT_HTTP_REQUEST_COUNT 3

#define INTERNAL_TIME_OUT   45

@interface HTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;

@end

@implementation HTTPManager

- (id)init{
    if (self = [super init]) {
        _afManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        [_afManager.operationQueue setMaxConcurrentOperationCount:MAX_CONCURRENT_HTTP_REQUEST_COUNT];
        _afManager.completionQueue = dispatch_queue_create("zhihu.completion.queue", DISPATCH_QUEUE_SERIAL);
        _afManager.requestSerializer.timeoutInterval = INTERNAL_TIME_OUT;
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLPath parameters:(NSDictionary *)parameters modelClass:(Class)modelClass success:(void (^)(NSURLSessionDataTask *, BaseResponseModel *))success failure:(void (^)(NSURLSessionDataTask *, BaseResponseModel *))failure{
    NSAssert(modelClass, @"modelClass cannot be nil");
    NSAssert(URLPath, @"url path cannot be nil");

    WEAK_REF(self)
    NSURLSessionDataTask *op = [_afManager GET:URLPath parameters:parameters progress:nil success:^(NSURLSessionDataTask *task,id responseObject){
        STRONG_REF(self_)
        if (self__) {
            [self__ parseSuccessResponse:responseObject task:task modelClass:modelClass success:success failure:failure];
        }
    }failure:^(NSURLSessionDataTask *task,NSError *error){
        STRONG_REF(self_)
        if (self__) {
            BaseResponseModel *baseModel = [self__ failureResponseModelWithTask:task];
            dispatch_main_async_safe(^{
                if (failure) {
                    failure(task,baseModel);
                }
            })
        }
    }];
    
    return op;
}

-(void)parseSuccessResponse:(id)responseObject
                  task:(NSURLSessionDataTask *)task
                 modelClass:(Class)modelClass
                    success:(void (^)(NSURLSessionDataTask *, BaseResponseModel *))success
                    failure:(void (^)(NSURLSessionDataTask *, BaseResponseModel *))failure{
    NSError *error;
    BaseResponseModel *baseModel = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:responseObject error:&error];
    
    dispatch_main_async_safe(^{
        if (baseModel && [baseModel isKindOfClass:modelClass]) {
            if (success) {
                success(task, baseModel);
            }
        }else if (![baseModel isKindOfClass:modelClass]){
            if (failure) {
                failure(task, baseModel);
            }
        }else{
            if (failure) {
                BaseResponseModel *errorModel = [[BaseResponseModel alloc] initWithErrorCode:HttpRequestParseErrorType errorMsg:@"解析错误"];
                failure(task, errorModel);
            }
        }
    })
}

- (BaseResponseModel *)failureResponseModelWithTask:(NSURLSessionDataTask *)op
{
    NSError *error = [op error];
    
    int errorCode = HttpRequestGeneralErrorType;
    
    switch ([error code]) {
        case NSURLErrorTimedOut:
            errorCode = HttpRequestTimedOutErrorType;
            break;
            
        case NSURLErrorCancelled:
            errorCode = HttpRequestCancelErrorType;
            break;
            
        case NSURLErrorUnsupportedURL:
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorDNSLookupFailed:
        case NSURLErrorHTTPTooManyRedirects:
            errorCode = HttpConnectionFailureErrorType;
            break;
        default:
            errorCode = HttpRequestGeneralErrorType;
            break;
    }
    
    BaseResponseModel *errorModel = [[BaseResponseModel alloc] initWithErrorCode:errorCode errorMsg:[error description]];
    return errorModel;
    
}


@end
