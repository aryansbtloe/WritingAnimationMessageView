//
//  AKSInfoMessageView.m
//  WritingAnimationMessageView
//
//  Created by Alok on 30/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "AKSInfoMessageView.h"
#import "AppDelegate.h"
#import "QuartzCore/QuartzCore.h"

static AKSInfoMessageView *_AKSInfoMessageView = nil;

@implementation AKSInfoMessageView

@synthesize imageView,messageView;

+ (AKSInfoMessageView *)sharedAKSInfoMessageView
{
	TCSTART
	
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
		if (_AKSInfoMessageView==nil) {
			_AKSInfoMessageView = [[[NSBundle mainBundle] loadNibNamed:@"AKSInfoMessageView"
																 owner:((AppDelegate*)[[UIApplication sharedApplication]delegate]) options:nil]objectAtIndex:0];
		}
    });
	return _AKSInfoMessageView;
	
	TCEND
}

+(id)alloc
{
	NSAssert(_AKSInfoMessageView == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

-(void)aksInfoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly isAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame
{
	TCSTART
	
	[self setHidden:FALSE];
	
	if (clear)
		[messagesToShow removeAllObjects];
	
	if(!messagesToShow)
		messagesToShow = [[NSMutableArray alloc]init];
	
	if (message&&message.length>0)
	{
		NSMutableDictionary * Info = [[NSMutableDictionary alloc]init];
		[Info setObject:message forKey:@"Message"];
		[Info setObject:[NSNumber numberWithFloat:duration] forKey:@"Duration"];
		[Info setObject:[NSNumber numberWithInt:size] forKey:@"FontSize"];
		[Info setObject:[NSNumber numberWithBool:showTextOnly] forKey:@"ShowTextOnly"];
		[Info setObject:[NSNumber numberWithBool:isAnimationRequired] forKey:@"IsAnimationRequired"];
		[Info setObject:[NSNumber numberWithInt:r] forKey:@"RGB_r"];
		[Info setObject:[NSNumber numberWithInt:g] forKey:@"RGB_g"];
		[Info setObject:[NSNumber numberWithInt:b] forKey:@"RGB_b"];
		[Info setObject:[NSNumber numberWithBool:blink] forKey:@"Blink"];
		[Info setObject:[NSNumber numberWithBool:isWritingAnimation] forKey:@"IsWritingAnimation"];
		[Info setObject:[NSValue valueWithCGRect:Frame] forKey:@"Frame"];
		[messagesToShow addObject:Info];
	}
	
	if (messagesToShow.count>0&&(!isAlreadyShowing))
	{
		isCancelled=FALSE;
		isAlreadyShowing = TRUE;
		[messageView.layer removeAllAnimations];
		[messageView setAlpha:1.0f];
		
		NSMutableDictionary* Info  = [messagesToShow objectAtIndex:0];
		
		if (((NSNumber*)[Info objectForKey:@"Blink"]).boolValue)
			[self Blink];
		
		disappeared = FALSE;
		messageView.backgroundColor=[UIColor clearColor];
		[messageView setShowsVerticalScrollIndicator:TRUE];
		messageView.layer.cornerRadius = 10.0;
		messageView.layer.masksToBounds = YES;
		imageView.layer.cornerRadius = 10.0;
		imageView.layer.masksToBounds = YES;
		messageView.opaque=NO;
		
		textToDisplay = [Info objectForKey:@"Message"];
				
		if ((((NSValue*)[Info objectForKey:@"Frame"]).CGRectValue).size.width>0)
		{
			[imageView setFrame:(((NSValue*)[Info objectForKey:@"Frame"]).CGRectValue)];
			[messageView setFrame:(((NSValue*)[Info objectForKey:@"Frame"]).CGRectValue)];
		}
		else
		{
            CGRect mainScreenBounds = [[UIScreen mainScreen]bounds];
            CGRect globalRect = CGRectInset(mainScreenBounds,mainScreenBounds.size.width/2-mainScreenBounds.size.width/3,mainScreenBounds.size.height/2-mainScreenBounds.size.height/3);
			[imageView setFrame:globalRect];
			[messageView setFrame:globalRect];
		}
		
		if (!((NSNumber*)[Info objectForKey:@"IsWritingAnimation"]).boolValue)
			[messageView setText:textToDisplay];
		else
		{
			noOfCharacters = textToDisplay.length;
			charPos=0;
			[self writingAnimation];
		}
		
		[messageView setTextColor:[UIColor whiteColor]];
		
		[messageView setTextColor:[UIColor colorWithRed:((NSNumber*)[Info objectForKey:@"RGB_r"]).intValue green:((NSNumber*)[Info objectForKey:@"RGB_g"]).intValue blue:((NSNumber*)[Info objectForKey:@"RGB_b"]).intValue alpha:1]];
		
		[messageView setFont:[UIFont fontWithName:@"Marker Felt" size:((NSNumber*)[Info objectForKey:@"FontSize"]).floatValue]];
		
		if (((NSNumber*)[Info objectForKey:@"ShowTextOnly"]).boolValue==TRUE)
		{
			[imageView setHidden:TRUE];
			[messageView setShowsVerticalScrollIndicator:FALSE];
		}
		else
		{
			[imageView setHidden:FALSE];
			[messageView setShowsVerticalScrollIndicator:TRUE];
		}
		
		duration_ = ((NSNumber*)[Info objectForKey:@"Duration"]).floatValue;	
		[((AppDelegate*)[[UIApplication sharedApplication]delegate]).window addSubview:self];	
		
		if (((NSNumber*)[Info objectForKey:@"IsAnimationRequired"]).boolValue==TRUE)
		{
			[self showAnimationAsIfMoving:messageView IsShowing:YES];
			[NSTimer scheduledTimerWithTimeInterval:duration_
											 target:self
										   selector:@selector(finish1:)
										   userInfo:nil
											repeats:NO];
		}
		else
		{
			[NSTimer scheduledTimerWithTimeInterval:duration_
											 target:self
										   selector:@selector(finish2:)
										   userInfo:nil
											repeats:NO];
		}
		
		[messagesToShow removeObjectAtIndex:0];
	}
	
	TCEND
}


-(void)showAnimationAsIfMoving:(id)Object IsShowing:(bool) IsShowing
{
	TCSTART
	
	if (isCancelled)return;
	
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
		
		float Distance1 = 320.0f;
		float Distance2 = 320.0f;
		
		if (IsShowing)
		{
			[animation setDuration:0.3];
			Distance1=320;
			Distance2=0;
		}
		else
		{			
			[animation setDuration:0.5];
			Distance1=0;
			Distance2=320;
		}
		[animation setRepeatCount:0];
		[animation setAutoreverses:NO];
		[animation setFromValue:[NSValue valueWithCGPoint:
								 CGPointMake([Object center].x - Distance1, [Object center].y)]];
		[animation setToValue:[NSValue valueWithCGPoint:
							   CGPointMake([Object center].x + Distance2, [Object center].y)]];
		[[Object layer] addAnimation:animation forKey:@"position"];
	
	TCEND
}


-(void)finish2:(NSTimer*)Sender
{
	TCSTART
	
	if (isCancelled)return;
	
	isAlreadyShowing = FALSE;
	
	if (messagesToShow.count>0)
	{
		[self aksInfoMessageFor:0 withMessage:@"" withFontSize:0 ShowTextOnly:YES isAnimationRequired:NO ClearPreviousMessages:NO ColorWithR:0 G:0 B:0 IsBlinking:NO IsWritingAnimation:NO Frame:CGRectZero];
		return;
	}
	
	[self setHidden:TRUE];
	
	TCEND
}


-(void)finish1:(NSTimer*)Sender
{
	TCSTART
	
	if (isCancelled)return;
	
	if (disappeared)
	{
		isAlreadyShowing = FALSE;
		if (messagesToShow.count>0)
		{
			[self aksInfoMessageFor:0 withMessage:@"" withFontSize:0 ShowTextOnly:YES isAnimationRequired:NO ClearPreviousMessages:NO ColorWithR:0 G:0 B:0 IsBlinking:NO IsWritingAnimation:NO Frame:CGRectZero];
			return;
		}
		[self setHidden:TRUE];
	}
	else
	{
		[self showAnimationAsIfMoving:messageView IsShowing:NO];
		disappeared = TRUE;
		
		[NSTimer scheduledTimerWithTimeInterval:0.4
										 target:self
									   selector:@selector(finish1:)
									   userInfo:nil
										repeats:NO];
	}
	
	TCEND
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self cleanUpEverything];
}

-(void)cleanUpEverything
{
	TCSTART
	
		isCancelled = TRUE;
		messageView.text=@"";
		[self setHidden:TRUE];
		[messagesToShow removeAllObjects];
		isAlreadyShowing = FALSE;
	
	TCEND
}



- (void)Blink
{
	TCSTART
	
	[messageView setAlpha:0.0];
	[UIView beginAnimations:@"Blink" context:nil];
	
	[UIView setAnimationDuration:.2];
	[UIView setAnimationRepeatAutoreverses:YES];
	
	[UIView setAnimationRepeatCount:640];
	
	[UIView setAnimationDelegate:self];
	
	[messageView setAlpha:1.0f];	
	
	[UIView commitAnimations];
	
	TCEND
}


-(void)writingAnimation
{
	TCSTART
	
	if (isCancelled)return;
	
	if ((charPos+1)<=noOfCharacters) 
		[messageView setText:[NSString stringWithFormat:@"%@ _",[textToDisplay substringToIndex: charPos]]];
	
	else
		[messageView setText:[NSString stringWithFormat:@"%@",textToDisplay]];
	
	charPos++;
	
	float time1;
	float time2;
	float time3;
	
	if (textToDisplay.length>32)
	{
		time1 = 0.09;
		time2 = 0.05;
		time3 = 0.01;
	}
	else
	{
		time1 = 0.2;
		time2 = 0.1;
		time3 = 0.05;
	}
	
	if (charPos<=noOfCharacters) 
	{
		int RandomNo = arc4random()%(int)6;
		
		if (RandomNo>4)
		{
			[NSTimer scheduledTimerWithTimeInterval:time1 target:self selector:@selector(writingAnimation)
										   userInfo:nil
											repeats:NO];
		}
		else if (RandomNo>2)
		{
			[NSTimer scheduledTimerWithTimeInterval:time2
											 target:self
										   selector:@selector(writingAnimation)
										   userInfo:nil
											repeats:NO];
		}
		else
		{
			[NSTimer scheduledTimerWithTimeInterval:time3
											 target:self
										   selector:@selector(writingAnimation)
										   userInfo:nil
											repeats:NO];
		}
	}
	
	TCEND
}

@end