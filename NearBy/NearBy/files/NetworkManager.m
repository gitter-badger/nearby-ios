//
//  NSNetworkManager.m
//  StadiumNeue
//
//  Created by Nick Sparks on 9/26/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import "NetworkManager.h"
#import "Model.h"

NSString* baseURL = @"http://www.alihm.net:9000/api";
NSString* htmlBaseURL = @"http://www.alihm.net:9000/html";

@implementation NetworkManager

+ (instancetype) sharedInstance
{
  static NetworkManager *sharedInstance = nil;
  static dispatch_once_t onceToken = 0;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    // Do any other initialisation stuff here
    sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
    sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
  });
  return sharedInstance;
}

- (void) getAllBeaconMacAddresses:(void (^)(NSURLSessionDataTask *task, NSArray* addresses))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self call:GET payload:@[@"beacons", @"mac"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    [[Model sharedInstance] setValidAddresses:responseObject];
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (NSURL*) getURLForBeaconWithAddress:(NSString*)address
{
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", htmlBaseURL, address]];
}

- (void) getPageForBeaconWithAddress:(NSString*)address success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self call:GET payload:@[@"beacons", address, @"html"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

#pragma mark - Helper Methods

- (NSArray*) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass
{
  
  if([json isKindOfClass:[NSDictionary class]]){
    
    NSMutableArray *tempKeys = [[(NSDictionary *) json allKeys] mutableCopy];
    
    id testObject = [[theClass alloc] init];
    for (NSString* key in tempKeys) {
      if (![testObject respondsToSelector:NSSelectorFromString(key)]) {
        [tempKeys removeObject:key];
        NSLog(@"key %@ was not used while parsing json.", key);
      }
    }
    
    NSArray* keys = [tempKeys copy];
    
    id newItem = [[theClass alloc] init];
    
    //assign properties
    for (NSString* key in keys) {
      id value = [json valueForKey:key];
      [newItem setValue:value forKey:key];
    }
    
    return newItem;
  } else {
    NSArray* array = json;
    
    if ([array count] == 0) {
      return nil;
    }
    
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    
    //find the valid keys for this class
    NSMutableArray* tempKeys = [[array[0] allKeys] mutableCopy];
    id testObject = [[theClass alloc] init];
    for (NSString* key in tempKeys) {
      if (![testObject respondsToSelector:NSSelectorFromString(key)]) {
        [tempKeys removeObject:key];
        NSLog(@"key %@ was not used while parsing json.", key);
      }
    }
    NSArray* keys = [tempKeys copy];
    
    for (NSDictionary* item in array) {
      id newItem = [[theClass alloc] init];
      
      //assign properties
      for (NSString* key in keys) {
        id value = [item valueForKey:key];
        [newItem setValue:value forKey:key];
      }
      //insert the item into the array
      [newArray insertObject:newItem atIndex:[newArray count]];
    }
    return [newArray copy];
  }
}

- (void) call:(CALL_TYPE)action payload:(NSArray*)payload parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  NSString* call = @"";
  for (NSString *item in payload){
    call = [call stringByAppendingPathComponent:item];
  }
  [self genericCall:action path:call parameters:parameters success:success failure:failure];
}

- (void) checkResponseStatus:(id)responseObject success:(void (^)(id responseObject))success failure: (void (^)(NSString* statusCode, NSString* description))failure
{
  // nooooooo
}

- (void) genericCall:(CALL_TYPE)action path:(NSString*)path parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  switch (action)
  {
    case GET:
      [self genericGet:path parameters:parameters success:success failure:failure];
      break;
    case POST:
      [self genericPost:path parameters:parameters success:success failure:failure];
      break;
    case PUT:
      [self genericPut:path parameters:parameters success:success failure:failure];
      break;
    case DELETE:
      [self genericDelete:path parameters:parameters success:success failure:failure];
      break;
  }
}

- (void) genericGet:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self GET:pathString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) genericPost:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self POST:pathString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) genericPut:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self PUT:pathString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) genericDelete:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self DELETE:pathString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}


@end
