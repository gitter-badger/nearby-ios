//
//  Model.m
//  StadiumNeue
//
//  Created by Shelby Vanhooser on 9/27/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import "Model.h"
#import "NetworkManager.h"

@implementation Model

+ (instancetype) sharedInstance
{
  static Model *sharedInstance = nil;
  static dispatch_once_t onceToken = 0;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[[self class] alloc] init];
    //Initialize any other parameters
  });
  return sharedInstance;
}


- (BOOL) addressIsValid:(NSString*)address
{
  for (NSString* a in self.validAddresses)
  {
    if ([address isEqualToString:a])
    {
      return YES;
    }
  }
  return NO;
}

@end
