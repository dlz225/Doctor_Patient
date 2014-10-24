//
//  DCAPIClient.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/19.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"

#import "AFURLConnectionOperation.h"

static NSString * const kDCAPIBaseUrlString = @"http://192.168.1.132:8080/StoryBookServer2.0/";


//static NSString * const kDCAPIBaseUrlString = @"http://192.168.1.99:9999/StoryBookServer2.0/";

//static NSString * const kDCAPIBaseUrlString = @"http://192.168.2.4:8001/";




//static NSString * const kDCAPIBaseUrlString = @"http://192.168.1.132:9000/";


@implementation DCAPIClient


+ (instancetype)sharedAPIClient{

    static DCAPIClient *clinet = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        clinet = [[DCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kDCAPIBaseUrlString]];
    });
    
    return clinet;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Source" value:@"ef5633d4-0575-4ca5-9ebd-a16bb4dc8b2e"];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self.operationQueue setMaxConcurrentOperationCount:5];

    }
    
    return self;
}

- (void)setAccessToken:(NSString*)token{
    NSString* cookieValue = [NSString stringWithFormat:@"pickup_sess_id=%@",token];
    [self setDefaultHeader:@"Cookie" value:cookieValue];
}


+ (void)userAuth:(NSString *)path
      parameters:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *, id))success
         failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    DCAPIClient *sharedClient = [[DCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kDCAPIBaseUrlString]];
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    [sharedClient postPath:path
                parameters:params
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       success(operation,responseObject);
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       failure(operation,error);
                   }];
}


- (AFHTTPRequestOperation *)getPath:(NSString *)path
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    //  LogDebug(@"Get\nAPI:%@\nParam:%@ ",path,parameters);
    [self setParameterEncoding:AFFormURLParameterEncoding];
    AFHTTPRequestOperation *operation = [super getPath:path
                                            parameters:parameters
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   LogDebug(@"\nGet\nAPI:%@\nResponse:%@\nCookie:%@",path,responseObject,operation.request.allHTTPHeaderFields);
                                                   __block AFHTTPRequestOperation* blockOp = operation;
                                                   __block id blockObj = responseObject;
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       success(blockOp,blockObj);
                                                   });
                                               }
                                         
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   NSLog(@"\nGet\nAPI:%@\nError:%@",path,error);
                                                   __block AFHTTPRequestOperation* blockOp = operation;
                                                   __block NSError* blockError = error;
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       failure(blockOp,blockError);
                                                   });
                                               }];
    return operation;
}




- (void)JSONPostPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(AFHTTPRequestOperation *, id))success
             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSLog(@"Post\nAPI:%@\nParam:%@",path,parameters);
    [self setParameterEncoding:AFJSONParameterEncoding];
    [super postPath:path
         parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"\nPost\nAPI:%@\nResponse:%@",path,responseObject);
                success(operation,responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"\nPost\nAPI:%@\nError:%@",path,error);
                failure(operation,error);
            }];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
            body:(NSString*)body
      completion:(void (^)(NSDictionary* dict, NSError* error))completion{
    NSLog(@"Post\nAPI:%@\nParam:%@",path,parameters);
    NSMutableData *data = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* afRequest = [self requestWithMethod:@"Post"
                                                        path:path
                                                  parameters:parameters];
    [afRequest setTimeoutInterval:60.0];
    [afRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afRequest setHTTPBody:data];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:afRequest
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        __block id blockJSON = JSON;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(blockJSON, nil);
                                                        });
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failure Uploading to :\n%@", error);
                                                        __block id blockError = error;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(nil,blockError);
                                                        });
                                                        
                                                    }];
    
    [operation start];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *, id))success
         failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSLog(@"Post\nAPI:%@\nParam:%@",path,parameters);
    [self setParameterEncoding:AFFormURLParameterEncoding];
    [super postPath:path
         parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                __block AFHTTPRequestOperation* blockOp = operation;
                __block id blockObj = responseObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    LogDebug(@"\nPost\nAPI:%@\nResponse:%@",path,responseObject);
                    success(blockOp,blockObj);
                });
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                __block AFHTTPRequestOperation* blockOp = operation;
                __block NSError* blockError = error;
                dispatch_async(dispatch_get_main_queue(), ^{
                    LogDebug(@"\nPost\nAPI:%@\nError:%@",path,error);
                    failure(blockOp,blockError);
                });
                
            }];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           body:(NSString*)body
     completion:(void (^)(NSDictionary* dict, NSError* error))completion {
    NSLog(@"Post\nAPI:%@\nParam:%@",path,parameters);
    NSMutableData *data = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* afRequest = [self requestWithMethod:@"PUT"
                                                        path:path
                                                  parameters:parameters];
    [afRequest setTimeoutInterval:60.0];
    [afRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afRequest setHTTPBody:data];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:afRequest
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        __block id blockJSON = JSON;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(blockJSON, nil);
                                                        });
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failure Uploading to :\n%@", error);
                                                        __block id blockError = error;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(nil,blockError);
                                                        });
                                                        
                                                    }];
    
    [operation start];
}

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
              body:(NSString*)body
        completion:(void (^)(NSDictionary* dict, NSError* error))completion {
    NSLog(@"Post\nAPI:%@\nParam:%@",path,parameters);
    NSMutableData *data = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* afRequest = [self requestWithMethod:@"DELETE"
                                                        path:path
                                                  parameters:parameters];
    [afRequest setTimeoutInterval:60.0];
    [afRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afRequest setHTTPBody:data];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:afRequest
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        __block id blockJSON = JSON;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(blockJSON, nil);
                                                        });
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failure Uploading to :\n%@", error);
                                                        __block id blockError = error;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(nil,blockError);
                                                        });
                                                        
                                                    }];
    
    [operation start];
}




@end
