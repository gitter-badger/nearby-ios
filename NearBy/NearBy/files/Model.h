//
//  Model.h
//  StadiumNeue
//
//  Created by Shelby Vanhooser on 9/27/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+(instancetype) sharedInstance;

@property (strong, nonatomic) NSArray *validAddresses;

- (BOOL) addressIsValid:(NSString*)address;

@end
