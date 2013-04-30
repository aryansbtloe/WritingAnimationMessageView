//
//  ViewController.m
//  WritingAnimationMessageView
//
//  Created by Alok on 30/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [((AppDelegate*)[[UIApplication sharedApplication]delegate]) aksInfoMessageFor:5 withMessage:@"This is a demo text message....with lots of options to configure" withFontSize:30 ShowTextOnly:YES IsAnimationRequired:NO ClearPreviousMessages:YES ColorWithR:255 G:0 B:0 IsBlinking:NO IsWritingAnimation:YES Frame:CGRectZero];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
