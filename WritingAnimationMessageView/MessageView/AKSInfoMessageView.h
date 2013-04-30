//
//  AKSInfoMessageView.h
//  WritingAnimationMessageView
//
//  Created by Alok on 30/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#ifndef UseTryCatch
#define UseTryCatch 1//use 0 to disable and 1 to enable the try catch throughout the application


//Warning:Do not Enable this Macro for general purpose...use it if u are intentionally dubbugging for some unexpected method calls
#ifndef UsePTMName
#define UsePTMName 0//use 0 to disable and 1 to enable printing the method name throughout the application


#if UseTryCatch


#if UsePTMName
#define TCSTART @try{NSLog(@"\n%s\n",__PRETTY_FUNCTION__);
#else
#define TCSTART @try{
#endif

#define TCEND  }@catch(NSException *e){NSLog(@"\n\n\n\n\n\n\
\n\n|EXCEPTION FOUND HERE...PLEASE DO NOT IGNORE\
\n\n|FILE NAME         %s\
\n\n|LINE NUMBER       %d\
\n\n|METHOD NAME       %s\
\n\n|EXCEPTION REASON  %@\
\n\n\n\n\n\n\n",strrchr(__FILE__,'/'),__LINE__, __PRETTY_FUNCTION__,e);};


#else

#define TCSTART
#define TCEND

#endif
#endif


#endif
/////////////////////MACROS TO BE VISIBLE THROUGHT THE APPLICATION//////////////////////////////

@interface AKSInfoMessageView : UIView 
{
	IBOutlet UITextView * messageView;
	IBOutlet UIImageView * imageView;
	float duration_;
	BOOL disappeared;
	NSMutableArray * messagesToShow;
	BOOL isAlreadyShowing;
	NSString* textToDisplay;
	int noOfCharacters;
	int charPos;
	BOOL isCancelled;
}
@property(nonatomic,retain)IBOutlet UITextView * messageView;
@property(nonatomic,retain)IBOutlet UIImageView * imageView;

-(void)aksInfoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly isAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame;
+ (AKSInfoMessageView *)sharedAKSInfoMessageView;
-(void)cleanUpEverything;
@end
