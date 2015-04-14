//
//  CameraViewController.h
//  Hoversafe Assistant
//
//  Created by Simon Anthony on 09/04/2015.
//  Copyright (c) 2015 Autonomous Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface CameraViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, NSStreamDelegate>

@property CGPoint minPoint;
@property CGPoint maxPoint;
@property CGPoint orbCenter;

@property (weak, nonatomic) IBOutlet UIImageView *orb;
@property (weak, nonatomic) IBOutlet UIView *boundaryView;
@property (weak, nonatomic) IBOutlet UILabel *lblCameraControl;

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (IBAction)toggleUI;

@end
