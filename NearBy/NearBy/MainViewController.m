//
//  MainViewController.m
//  StadiumNeue
//
//  Created by Shelby Vanhooser on 9/27/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import "MainViewController.h"
#import "Model.h"
#import "DetailViewController.h"
#import "NetworkManager.h"

@interface MainViewController ()

@property (strong, nonatomic) ESTBeaconManager *manager;
@property (strong, nonatomic) NSString * detailPath;
@property (strong, nonatomic) DetailViewController *detailView;

@property (strong, nonatomic) NSString *closestBeacon;
@property (strong, nonatomic) NSMutableArray *readings;
@property int at;
@property int queueSize;

@property int otherCount;
@property int changeThreshold;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.closestBeacon = @"";
  self.readings = [NSMutableArray new];
  self.at = 0;
  self.queueSize = 20;
  
  self.otherCount = 0;
  self.changeThreshold = 20;
  
  self.manager = [ESTBeaconManager new];
  //[ESTBeaconManager setupAppID:@"app_1ruzsi2brq" andAppToken:@"420c345df5f2093cfc9bdc09850d93dc"];
  self.manager.delegate = self;
  
  ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"Any"];
  
  [self.manager startEstimoteBeaconsDiscoveryForRegion:region];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
  for (ESTBeacon * beacon in beacons){
    if ([[Model sharedInstance] addressIsValid:beacon.macAddress]){
      if(![beacon.macAddress isEqualToString:self.closestBeacon]){
        self.otherCount++;
        if (self.otherCount > self.changeThreshold){
          self.closestBeacon = beacon.macAddress;
          self.readings = [NSMutableArray new];
          self.at = 0;
          self.otherCount = 0;
          [self parseBeaconReading:beacon];
          //Changed to other beacon
        }
      } else {
        [self parseBeaconReading:beacon];
        self.otherCount = 0;
      }
    }
    break;
  }
}

-(void)parseBeaconReading:(ESTBeacon *) beacon{
  [self.readings setObject:[NSNumber numberWithInt:(int) beacon.rssi] atIndexedSubscript:self.at];
  self.at = (self.at + 1) % self.queueSize;
  
  int reading = [self meteredBeaconReading];
  
  NSLog(@"Meterd reading now: %d", reading);
  if(reading > -70){
    if(!self.detailView){
      [self presentDetail];
    }
  } else {
    if(self.detailView){
      [self dismissDetail];
    }
  }
}

-(int)meteredBeaconReading{
  int sum = 0;
  for (NSNumber *num in self.readings){
    sum += num.intValue;
  }
  return sum / self.queueSize;
}

-(void) presentDetail {
  NSLog(@"Presenting detail");
  [self performSegueWithIdentifier:@"goToDetail" sender:self];
}

-(void) dismissDetail {
  [self dismissViewControllerAnimated:YES completion:^{
    self.detailView = nil;
  }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSLog(@"Path : %@", [[NetworkManager sharedInstance] getURLForBeaconWithAddress:self.closestBeacon].absoluteString);
  self.detailView = [segue destinationViewController];
  self.detailView.path = [[NetworkManager sharedInstance] getURLForBeaconWithAddress:self.closestBeacon];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
