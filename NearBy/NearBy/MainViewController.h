//
//  MainViewController.h
//  StadiumNeue
//
//  Created by Shelby Vanhooser on 9/27/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EstimoteSDK/ESTBeaconManager.h> 

@interface MainViewController : UIViewController <ESTBeaconManagerDelegate, ESTBeaconDelegate>

@end
