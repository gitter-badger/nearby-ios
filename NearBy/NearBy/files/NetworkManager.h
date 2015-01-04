//
//  NSNetworkManager.h
//  StadiumNeue
//
//  Created by Nick Sparks on 9/26/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

typedef enum {
  GET,
  POST,
  PUT,
  DELETE
} CALL_TYPE;

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype) sharedInstance;

- (void) getAllBeaconMacAddresses:(void (^)(NSURLSessionDataTask *task, NSArray* addresses))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getPageForBeaconWithAddress:(NSString*)address success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURL*) getURLForBeaconWithAddress:(NSString*)address;

#pragma mark - Helper Methods

- (NSArray*) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass;

- (void) call:(CALL_TYPE)action payload:(NSArray*)payload parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) checkResponseStatus:(id)responseObject success:(void (^)(id responseObject))success failure: (void (^)(NSString* statusCode, NSString* description))failure;

- (void) genericCall:(CALL_TYPE)action path:(NSString*)path parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericGet:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericPost:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericPut:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericDelete:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
