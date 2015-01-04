//
//  DetailViewController.h
//  StadiumNeue
//
//  Created by Shelby Vanhooser on 9/27/14.
//  Copyright (c) 2014 Nick Sparks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL * path;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
