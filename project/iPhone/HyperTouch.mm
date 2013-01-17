#import <UIKit/UIKit.h>
#include <HyperTouch.h>

//---------------------------------------------------------------------------------------------------
	
	typedef void( *FunctionType)( );
	extern "C"{
		
		void onTap( int iFingers , int iTaps , int iPhase , float fx , float fy );
		void onLongPress( int iFingers , int iTaps , int iPhase , float fx , float fy );
		void onSwipe( int iFingers , int iDir , float fVx , float fVy , float fDx , float fDy );
		void onPinch( int iPhase , float dx , float dy ,float fScale );
		void onPan( int iPhase , float dx , float dy , float vx , float vy );
		void onRot( int phase , float fx , float fy , float deg );		
	} 

//Interface

	@interface TouchDelegate : NSObject<UIGestureRecognizerDelegate>{ }

		@property ( nonatomic ) FunctionType fOnTap;
		@property ( nonatomic ) FunctionType fOnSwipe;
		@property ( nonatomic ) FunctionType fOnRot;
		@property ( nonatomic ) FunctionType fOnPan;
		@property ( nonatomic ) FunctionType fOnPinch;

		- ( void ) activate:( int ) code;
		- ( void ) deactivate:( int ) code;

		//-( bool ) testGesture : ( NSString* ) codeName;
		-( int ) getOrientation;
		-( void ) handlePan   : ( UIPanGestureRecognizer * ) recognizer;
		-( void ) handlePinch : ( UIPinchGestureRecognizer * ) recognizer;
		-( void ) handleRot   : ( UIRotationGestureRecognizer *) recognizer;
		-( void ) handleSwipe : ( UISwipeGestureRecognizer *)recognizer;
		-( void ) handleTap   : ( UITapGestureRecognizer *) recognizer;
		-( void ) testView;
		-( void ) initGestures;
		-( int ) translateState:( UIGestureRecognizerState ) state;
		//-( BOOL )gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer ;
	@end

// Implementation

	@implementation TouchDelegate

		UIPanGestureRecognizer       	*gPan		= nil;
		UIPinchGestureRecognizer     	*gPinch		= nil;
		UIRotationGestureRecognizer  	*gRotate	= nil;
		UISwipeGestureRecognizer     	*gSwipeB	= nil;
		UISwipeGestureRecognizer     	*gSwipeL	= nil;
		UISwipeGestureRecognizer     	*gSwipeR	= nil;
		UISwipeGestureRecognizer     	*gSwipeT	= nil;
		UITapGestureRecognizer       	*gSingleTap	= nil;
		UITapGestureRecognizer       	*gDoubleTap	= nil;
		UITapGestureRecognizer       	*gTwixTap	= nil;
		UILongPressGestureRecognizer    *gLongPress	= nil;

		UIView *refView;
		BOOL bInit;

		@synthesize fOnTap;
		@synthesize fOnSwipe;
		@synthesize fOnRot;
		@synthesize fOnPan;
		@synthesize fOnPinch;
		
		//
			- ( id ) init {
				NSLog( @"init" );
				self = [ super init ];
				return self;
			}

			- ( void ) dealloc {
				NSLog( @"dealloc" );
				[ super dealloc ];
			}

			- ( int ) getOrientation{
				return [UIApplication sharedApplication].statusBarOrientation;
			}

		//
			- ( void ) activate:( int ) code{

				NSLog( @"activate ::: %i",code );

				if( bInit == false )
					[ self initGestures ];

				switch( code ){					
					case 0:
						NSLog(@"gSingleTap");
						gSingleTap.enabled = YES;
						break;

					case 1:
						gDoubleTap.enabled = YES;
						break;

					case 2:
						gTwixTap.enabled = YES;
						break;

					case 3:
						gPan.enabled = YES;
						break;

					case 4:
						gPinch.enabled = YES;
						break;

					case 5:
						gRotate.enabled = YES;
						break;

					case 6:
						gSwipeB.enabled = YES;
						gSwipeT.enabled = YES;
						gSwipeL.enabled = YES;
						gSwipeR.enabled = YES;
						break;

					case 7:
						NSLog(@"longpress");
						gLongPress.enabled = YES;
				}
			}

			- ( void ) deactivate :( int ) code{
				NSLog( @"deactivate ::: %i",code );		
				switch( code ){

					case 0:
						gSingleTap.enabled = NO;
						break;

					case 1:
						gDoubleTap.enabled = NO;
						break;

					case 2:
						gTwixTap.enabled = NO;
						break;

					case 3:
						gPan.enabled = NO;
						break;

					case 4:
						gPinch.enabled = NO;
						break;

					case 5:
						gRotate.enabled = NO;
						break;

					case 6:
						gSwipeB.enabled = NO;
						gSwipeT.enabled = NO;
						gSwipeL.enabled = NO;
						gSwipeR.enabled = NO;
						break;

					case 7:
						gLongPress.enabled = NO;
				}		
			}

			- (void ) testView{
				refView = [[UIView alloc] initWithFrame:CGRectMake(0,0,2,2)];
		        refView.alpha = 0;
		        [[[UIApplication sharedApplication] keyWindow] addSubview:refView];
			}

			-( void ) initGestures{
				NSLog( @"initGestures");

				//
					gPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
					gPinch.delegate = self;
					gPinch.enabled = false;
					[ gPinch setCancelsTouchesInView : NO ];
    				[[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gPinch ];

				//Pan Gesture
					gPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
					gPan.delegate = self;
					gPan.enabled = false;
					[ gPan setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gPan ];

				//Single Tap
					gSingleTap          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
					gSingleTap.enabled  = false;
					gSingleTap.delegate = self;
					[ gSingleTap setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gSingleTap ];

				//Double Tap
					gDoubleTap          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
					gDoubleTap.enabled  = false;
					gDoubleTap.delegate = self;
					[ gDoubleTap setNumberOfTapsRequired    : 2 ];
					[ gDoubleTap setNumberOfTouchesRequired : 1 ];
					[ gDoubleTap setCancelsTouchesInView    : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gDoubleTap ];

				//Two Fingers Tap
					gTwixTap          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
					gTwixTap.enabled  = false;
					gTwixTap.delegate = self;
					[ gTwixTap setNumberOfTapsRequired    : 1 ];
					[ gTwixTap setNumberOfTouchesRequired : 2 ];
					[ gTwixTap setCancelsTouchesInView    : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gTwixTap ];

				//Mixer
					[gSingleTap requireGestureRecognizerToFail:gDoubleTap];
					[gSingleTap requireGestureRecognizerToFail:gTwixTap];

				//Rotation
					gRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRot:)];
					gRotate.delegate = self;
					gRotate.enabled = false;
					[ gRotate setCancelsTouchesInView : NO ];
    				[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gRotate ];

				//Swipe Left
					gSwipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
					[ gSwipeL setDirection : UISwipeGestureRecognizerDirectionLeft ];
					gSwipeL.enabled = false;
					gSwipeL.delegate = self;
					[ gSwipeL setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gSwipeL ];
					[gSwipeL requireGestureRecognizerToFail:gPan];

				//Swipe Right
					gSwipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
					[ gSwipeR setDirection : UISwipeGestureRecognizerDirectionRight ];
					gSwipeR.enabled = false;
					gSwipeR.delegate = self;
					[ gSwipeR setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gSwipeR ];

				//Swipe Top
					gSwipeT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
					[ gSwipeT setDirection : UISwipeGestureRecognizerDirectionUp ];
					gSwipeT.enabled = false;
					gSwipeT.delegate = self;
					[ gSwipeT setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gSwipeT ];

				//Swipe Bottom
					gSwipeB = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
					[ gSwipeB setDirection : UISwipeGestureRecognizerDirectionDown ];
					gSwipeB.enabled = false;
					gSwipeB.delegate = self;
					[ gSwipeB setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gSwipeB ];	

				//Long Press
					gLongPress          = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
					gLongPress.enabled  = false;
					gLongPress.delegate = self;
					[ gLongPress setCancelsTouchesInView : NO ];
					[ [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addGestureRecognizer:gLongPress ];

				bInit = true;			
			}

			- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
			   	/*
			   // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
			    //if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
			    //    return NO;

			   	if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
			        return NO;

			    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
			        return NO;

			    //UIPanGestureRecognizer
			    /*
			    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
			        return NO;
				
			    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
			        return NO;
				*/

			    return YES;
			}

		//---------------------------------------------------------------------------------------------------
			
			- ( void ) handleTap : ( UITapGestureRecognizer *) recognizer { 
				//NSLog( @"handleTap" );

				UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    			CGPoint pos = [recognizer locationInView:window.rootViewController.view];		

				onTap( 
							recognizer.numberOfTouchesRequired,
							recognizer.numberOfTapsRequired,
							[ self translateState:recognizer.state],
							pos.x,
							pos.y
						);

			}

			- (void)handleSwipe:( UISwipeGestureRecognizer *)recognizer {
				//NSLog( @"handleSwipe %i" , recognizer.direction );

				UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    			CGPoint pos = [recognizer locationInView:window.rootViewController.view];		

				onSwipe( 
							recognizer.numberOfTouchesRequired,
							recognizer.direction,
							0,
							0,
							pos.x,
							pos.y
						);

			}

			- (void) handleLongPress:(UILongPressGestureRecognizer *) recognizer{
				//NSLog( @"handleLongPress");
				CGPoint pos = [recognizer locationInView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];		

				onLongPress( 
							recognizer.numberOfTouchesRequired,
							recognizer.numberOfTapsRequired,
							[ self translateState:recognizer.state],
							pos.x,
							pos.y
						);			
			}

			- (void)handleRot:( UIRotationGestureRecognizer *) recognizer{
				onRot( [ self translateState:recognizer.state] , 0 , 0 , recognizer.rotation );//, recognizer.velocity );
			}

			- (void)handlePan:( UIPanGestureRecognizer * ) recognizer{

				CGPoint translation	= [ recognizer translationInView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
    			CGPoint velocity	= [ recognizer velocityInView:recognizer.view];

				onPan( 
							[self translateState:recognizer.state] , 
							translation.x , translation.y,
							velocity.x , velocity.y							
						);
			
			}

			-( void ) handlePinch:( UIPinchGestureRecognizer * ) recognizer{
				
				UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    			CGPoint pos = [recognizer locationInView:window.rootViewController.view];	

				onPinch( 
							[self translateState:recognizer.state] , 
							0 , 0 , 
							recognizer.scale
						);
				
				
			}

			-( int ) translateState:( UIGestureRecognizerState ) state{

				int res = -1;
				switch( state ){

					case UIGestureRecognizerStatePossible:
						res = 0;
						break;

   					case UIGestureRecognizerStateBegan:
						res = 0;
   						break;

   					case UIGestureRecognizerStateChanged:
						res = 1;
   						break;

   					case UIGestureRecognizerStateEnded:
						res = 2;
   						break;

   					case UIGestureRecognizerStateCancelled:
						res = -1;
   						break;

   					case UIGestureRecognizerStateFailed:
						res = -1;
   						break;

				}
				return res;
			}

		//---------------------------------------------------------------------------------------------------
			

	@end

//---------------------------------------------------------------------------------------------------
	
	//Callback externs
		extern "C"{
			
		}

	namespace Hyperfiction{
		
		const int TAP = 0;
	
		static bool *bTap_ON     = false;
		static bool *bTap2_ON    = false;
		static TouchDelegate *td;

		//
			void init_hyp_touch( ){
				NSLog( @"init" );
				td = [ TouchDelegate alloc ];
				[ td testView ];
			}


		//Activators
		//-----------------------------------------------------------
			
			bool activateGesture( int iGestureCode , int iFingers ){
				[ td activate : iGestureCode ];
				NSLog( @"activateGesture %i" , iGestureCode );
				NSLog( @"td %d" , td );
				return YES;
			}

			bool deactivateGesture( int iGestureCode ){
				NSLog( @"deactivateGesture %i" , iGestureCode );
				[ td deactivate : iGestureCode ];
				return YES;
			}

		//Misc

			int getOrientation( ){
				return [ td getOrientation ];
			}


	}
