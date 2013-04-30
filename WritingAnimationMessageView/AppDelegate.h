//
//  AppDelegate.h
//  WritingAnimationMessageView
//
//  Created by Alok on 30/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;


-(void)aksInfoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly IsAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame;

@end
