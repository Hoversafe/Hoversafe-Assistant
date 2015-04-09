//
//  CameraViewController.h
//  Hoversafe Assistant
//
//  Created by Simon Anthony on 09/04/2015.
//  Copyright (c) 2015 Autonomous Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;

@interface CameraViewController : UIViewController

@property CGPoint minPoint;
@property CGPoint maxPoint;
@property CGPoint orbCenter;

@property (weak, nonatomic) IBOutlet UIImageView *orb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *boundaryView;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end
