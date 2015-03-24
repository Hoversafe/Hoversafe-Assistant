//
//  ViewController.h
//  Hoversafe Assistant
//
//  Created by Simon Anthony on 24/03/2015.
//  Copyright (c) 2015 Autonomous Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;

@interface ViewController : UIViewController <NSStreamDelegate>

@property CGPoint minPoint;
@property CGPoint maxPoint;
@property CGPoint orbCenter;

@property (weak, nonatomic) IBOutlet UIImageView *orb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end