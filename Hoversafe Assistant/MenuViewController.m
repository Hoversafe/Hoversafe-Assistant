//
//  MenuViewController.m
//  Hoversafe Assistant
//
//  Created by Simon Anthony on 09/04/2015.
//  Copyright (c) 2015 Autonomous Technologies. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Hoversafe Assistant";
    
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = NO;
}

@end
