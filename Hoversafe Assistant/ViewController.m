//
//  ViewController.m
//  Hoversafe Assistant
//
//  Created by Simon Anthony on 24/03/2015.
//  Copyright (c) 2015 Autonomous Technologies. All rights reserved.
//

#import "ViewController.h"

NSString *testString;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set orb control boundaries
    _minPoint.x = ((super.view.center.x * 2) - 15) - super.view.center.x * 0.5;
    _minPoint.y = ((super.view.center.y * 2) - 105) - super.view.center.y * 0.4;
    _maxPoint.x = _minPoint.x + (super.view.center.x * 0.5);
    _maxPoint.y = _minPoint.y + (super.view.center.y * 0.4);
    
    // Set orb center point within boundaries
    _orbCenter.x = _minPoint.x + ((_maxPoint.x - _minPoint.x) / 2);
    _orbCenter.y = _minPoint.y + ((_maxPoint.y - _minPoint.y) / 2);
    
    // Create UIPanGestureRecognizer and add to orb view
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOrb:)];
    [self.orb addGestureRecognizer:panGestureRecognizer];
    
    // Create UITapGestureRecognizer and add to orb view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (resetOrb:)];
    [self.orb addGestureRecognizer:tapGestureRecognizer];
    
    // Initialise network connection
    [self initNetworkCommunication];
    
    // Load camera webpage
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://192.168.1.50/index.html"]];
    [self.webView loadRequest:request];
}

-(void)viewDidAppear:(BOOL)animated {
    // Reset orb to center point
    self.orb.center = _orbCenter;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GESTURE CONTROL //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)moveOrb:(UIPanGestureRecognizer *)panGestureRecognizer
{
    // Get current touch location
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    
    // Create new orb location point
    CGPoint newPoint;
    
    // Ensure new point is within X axis boundary and constrain if not
    if (touchLocation.x < _minPoint.x) newPoint.x = _minPoint.x;
    else if (touchLocation.x > _maxPoint.x) newPoint.x = _maxPoint.x;
    else newPoint.x = touchLocation.x;
    
    // Ensure new point is within Y axis boundary and constrain if not
    if (touchLocation.y < _minPoint.y) newPoint.y = _minPoint.y;
    else if (touchLocation.y > _maxPoint.y) newPoint.y = _maxPoint.y;
    else newPoint.y = touchLocation.y;
    
    // Set orb position to new point
    self.orb.center = newPoint;
    
    // At end of gesture take current orb position, convert to pulse length and send to server
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPoint = self.orb.center;
        
        finalPoint.x = [self map:finalPoint.x fromMinimum:_minPoint.x fromMaximum:_maxPoint.x toMinimum:410 toMaximum:820];
        finalPoint.y = [self map:finalPoint.y fromMinimum:_minPoint.y fromMaximum:_maxPoint.y toMinimum:410 toMaximum:820];
        
        NSLog(@"%.2f, %.2f", finalPoint.x, finalPoint.y);
        [self sendData:finalPoint];
    }
}

- (void)resetOrb:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // On tap, reset orb to center position with slide animation
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         self.orb.center = _orbCenter;
     }
                     completion:nil];
    
    // Convert orb center point to pulse length and send to server
    CGPoint finalPoint = self.orb.center;                                                                                                   // THIS
    finalPoint.x = [self map:finalPoint.x fromMinimum:_minPoint.x fromMaximum:_maxPoint.x toMinimum:410 toMaximum:820];                     // CAN
    finalPoint.y = [self map:finalPoint.y fromMinimum:_minPoint.y fromMaximum:_maxPoint.y toMinimum:410 toMaximum:820];                     // BE
    NSLog(@"%.2f, %.2f", finalPoint.x, finalPoint.y);                                                                                       // PRE
    [self sendData:finalPoint];                                                                                                             // DEFINED
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEND DATA ////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendData:(CGPoint)sender
{
    // Create YAW command string, convert to NSData type and push to output stream
    NSString *responseYaw = [NSString alloc];
    responseYaw = [NSString stringWithFormat:@"yaw:%.2f", sender.x];
    NSData *dataYaw = [[NSData alloc] initWithData:[responseYaw dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[dataYaw bytes] maxLength:[dataYaw length]];
    
    // Create PITCH command string, convert to NSData type and push to output stream
    NSString *responsePit = [NSString alloc];
    responsePit = [NSString stringWithFormat:@"pit:%.2f", sender.y];
    NSData *dataPit = [[NSData alloc] initWithData:[responsePit dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[dataPit bytes] maxLength:[dataPit length]];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INIT NETWORK COMMUNICATION ///////////////////////////////////////////////////////////////////////////////////////////

- (void)initNetworkCommunication                                                                                                            // COMMENT THIS SECTION
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.50", 81, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// STREAM EVENTS ////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent                                                                 // COMMENT THIS SECTION
{
    switch (streamEvent)
    {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream Opened");
            break;
        case NSStreamEventHasBytesAvailable:
            if(theStream == inputStream)
            {
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable])
                {
                    len = (int)[inputStream read:buffer maxLength:sizeof(buffer)];
                    if(len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output)
                        {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host");
            break;
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        default:
            NSLog(@"Unknown event");
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MISC FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////

- (float)map:(float)x fromMinimum:(float)in_min fromMaximum:(float)in_max toMinimum:(float)out_min toMaximum:(float)out_max
{
    // Map input value (x) from one range to another range
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


@end