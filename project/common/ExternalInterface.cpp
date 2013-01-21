
#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "hypertouch.h"
#include <stdio.h>

#ifdef ANDROID
	#include <hx/CFFI.h>
	#include <hx/Macros.h>
	#include <jni.h>

	/*
	extern JNIEnv *GetEnv();
	enum JNIType{
	   jniUnknown,
	   jniVoid,
	   jniObjectString,
	   jniObjectArray,
	   jniObject,
	   jniBoolean,
	   jniByte,
	   jniChar,
	   jniShort,
	   jniInt,
	   jniLong,
	   jniFloat,
	   jniDouble,
	};
	*/
	#define  LOG_TAG    "trace"
	#define  ALOG(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#endif

using namespace Hyperfiction;

// Callbacks ------------------------------------------------------------------------------------------------------------------

	AutoGCRoot *eval_callback_longpress = 0;
	AutoGCRoot *eval_callback_pan = 0;
	AutoGCRoot *eval_callback_pinch = 0;
	AutoGCRoot *eval_callback_swipe = 0;
	AutoGCRoot *eval_callback_tap = 0;
	AutoGCRoot *eval_callback_rot = 0;

	//Taps callback
		static value set_callback_tap( value onCall ){
			//printf("Set eval_callback_tap");
			eval_callback_tap = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_tap , 1 );

	//Longpress callback
		static value set_callback_long_press( value onCall ){
			//printf("set_callback_long_press");
			eval_callback_longpress = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_long_press , 1 );		

	//Swipe callback
		static value set_callback_swipe( value onCall ){
			//printf("set_callback_swipe");
			eval_callback_swipe = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_swipe , 1 );		

	//Pinch callback
		static value set_callback_pinch( value onCall ){
			//printf("set_callback_pinch");
			eval_callback_pinch = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_pinch , 1 );	

	//Pan callback
		static value set_callback_pan( value onCall ){
			//printf("set_callback_pan");
			eval_callback_pan = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_pan , 1 );	

	//Pan callback
		static value set_callback_rot( value onCall ){
			printf("set_callback_rot------------------------------------------");
			eval_callback_rot = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_rot , 1 );	


// Externs- ------------------------------------------------------------------------------------------------------------------


	extern "C" void test_hypertouch () {
		// Here you could do some initialization, if needed
	}
	DEFINE_ENTRY_POINT (test_hypertouch);

	extern "C" int hypertouch_register_prims () { return 0; }

// iPhone ------------------------------------------------------------------------------------------------------------------


#ifdef IPHONE
	
	//Misc

	static value HyperTouch_init( ){
		init_hyp_touch( );
		return alloc_null( );
	}
	DEFINE_PRIM( HyperTouch_init , 0 );

	static value HyperTouch_activate( value iGestureCode , value iFingers ){
		activateGesture( val_int( iGestureCode ) , val_int( iFingers ) );
		return alloc_null( );
	}
	DEFINE_PRIM( HyperTouch_activate , 2 );

	//Callbacks for iOS
	extern "C"{

		void onTap( int iFingers , int iTaps , int iPhase , float fx , float fy ){
			value args = alloc_array( 5 );
	    	val_array_set_i( args , 0 , alloc_int( iFingers ) );
	    	val_array_set_i( args , 1 , alloc_int( iTaps ) );
	    	val_array_set_i( args , 2 , alloc_int( iPhase ) );
	    	val_array_set_i( args , 3 , alloc_float( fx ) );
	    	val_array_set_i( args , 4 , alloc_float( fy ) );
	    	val_call1( eval_callback_tap -> get( ) , args ); 
	    	
		}

		void onSwipe( int iFingers , int iDir , float fVx , float fVy , float fDx , float fDy ){
			value args = alloc_array( 5 );
	    	val_array_set_i( args , 0 , alloc_int( iDir ) );
	    	val_array_set_i( args , 1 , alloc_float( fVx ) );
	    	val_array_set_i( args , 2 , alloc_float( fVy ) );
	    	val_array_set_i( args , 3 , alloc_float( fDx ) );
	    	val_array_set_i( args , 4 , alloc_float( fDy ) );
	    	val_call1( eval_callback_swipe -> get( ) , args ); 	
		}

		void onLongPress( int iFingers , int iTaps , int iPhase , float fx , float fy ){
			value args = alloc_array( 4 );
	    	val_array_set_i( args , 0 , alloc_int( iPhase ) );
	    	val_array_set_i( args , 1 , alloc_int( 0 ) );
	    	val_array_set_i( args , 2 , alloc_float( fx ) );
	    	val_array_set_i( args , 3 , alloc_float( fy ) );
	    	val_call1( eval_callback_longpress -> get( ) , args ); 	    	
		}

		void onPinch( int iPhase , float dx , float dy ,float fScale ){
			value args = alloc_array( 4 );
	    	val_array_set_i( args , 0 , alloc_int( iPhase ) );
	    	val_array_set_i( args , 1 , alloc_float( dx ) );
	    	val_array_set_i( args , 2 , alloc_float( dy ) );
	    	val_array_set_i( args , 3 , alloc_float( fScale ) );
	    	val_call1( eval_callback_pinch -> get( ) , args );       	
		}

		void onPan( int iPhase , float dx , float dy , float vx , float vy ){
			value args = alloc_array( 5 );
	    	val_array_set_i( args , 0 , alloc_int( iPhase ) );
	    	val_array_set_i( args , 1 , alloc_float( dx ) );
	    	val_array_set_i( args , 2 , alloc_float( dy ) );
	    	val_array_set_i( args , 3 , alloc_float( vx ) );
	    	val_array_set_i( args , 4 , alloc_float( vy ) );
	    	val_call1( eval_callback_pan -> get( ) , args );       	
		}

		void onRot( int iPhase , float fx , float fy , float deg ){
			value args = alloc_array( 4 );
	    	val_array_set_i( args , 0 , alloc_int( iPhase ) );
	    	val_array_set_i( args , 1 , alloc_float( fx ) );
	    	val_array_set_i( args , 2 , alloc_float( fy ) );
	    	val_array_set_i( args , 3 , alloc_float( deg ) );
	    	val_call1( eval_callback_rot -> get( ) , args ); 
	   }
	}


#endif

// Android ------------------------------------------------------------------------------------------------------------------

#ifdef ANDROID
extern "C"{

	JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_gestures_GestureTap_onTap(
																	JNIEnv * env, 
																	jobject  obj ,
																	jint iFingers,
																	jint iTaps,
																	jint iPhase,
																	jint iPointerId,
																	jfloat fx , 
																	jfloat fy ,
																	jfloat fPressure,
																	jfloat fSizeX,
																	jfloat fSizeY
    															){
    	
    	value args = alloc_array( 9 );
    	val_array_set_i( args , 0 , alloc_int( iFingers ) );
    	val_array_set_i( args , 1 , alloc_int( iTaps ) );
    	val_array_set_i( args , 2 , alloc_int( iPhase ) );
    	val_array_set_i( args , 3 , alloc_int( iPointerId ) );
    	val_array_set_i( args , 4 , alloc_float( fx ) );
    	val_array_set_i( args , 5 , alloc_float( fy ) );
    	val_array_set_i( args , 6 , alloc_float( fPressure ) );
    	val_array_set_i( args , 7 , alloc_float( fSizeX ) );
    	val_array_set_i( args , 8 , alloc_float( fSizeY ) );
        val_call1( eval_callback_tap -> get( ) , args ); 
       
    }

//
    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_gestures_GestureLongPress_onLongPress(
																	JNIEnv * env, 
																	jobject  obj ,
																	jint iPhase,
																	jint iPointerId,
																	jfloat fx , 
																	jfloat fy ,
																	jfloat fPressure,
																	jfloat fSizeX,
																	jfloat fSizeY
    															){
    	value args = alloc_array( 7 );
    	val_array_set_i( args , 0 , alloc_int( iPhase ) );
    	val_array_set_i( args , 1 , alloc_int( iPointerId ) );
    	val_array_set_i( args , 2 , alloc_float( fx ) );
    	val_array_set_i( args , 3 , alloc_float( fy ) );
    	val_array_set_i( args , 4 , alloc_float( fPressure ) );
    	val_array_set_i( args , 5 , alloc_float( fSizeX ) );
    	val_array_set_i( args , 6 , alloc_float( fSizeY ) );
        val_call1( eval_callback_longpress -> get( ) , args ); 
    }

//
    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_gestures_GestureSwipe_onSwipe(
																	JNIEnv * env, 
																	jobject  obj ,
																	jint dir,
																	jfloat vx , 
																	jfloat vy ,
																	jfloat dx , 
																	jfloat dy
    															){
    	value args = alloc_array( 5 );
    	val_array_set_i( args , 0 , alloc_int( dir ) );
    	val_array_set_i( args , 1 , alloc_float( vx ) );
    	val_array_set_i( args , 2 , alloc_float( vy ) );
    	val_array_set_i( args , 3 , alloc_float( dx ) );
    	val_array_set_i( args , 4 , alloc_float( dy ) );
      	val_call1( eval_callback_swipe -> get( ) , args ); 
    }

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_gestures_GesturePinch_onPinch(
																	JNIEnv * env, 
																	jobject  obj ,
																	jint iPhase,
																	jfloat dx , 
																	jfloat dy ,
																	jfloat scaleX , 
																	jfloat scaleY
    															){
    	
    	value args = alloc_array( 5 );
    	val_array_set_i( args , 0 , alloc_int( iPhase ) );
    	val_array_set_i( args , 1 , alloc_float( dx ) );
    	val_array_set_i( args , 2 , alloc_float( dy ) );
    	val_array_set_i( args , 3 , alloc_float( scaleX ) );
    	val_array_set_i( args , 4 , alloc_float( scaleY ) );
      	val_call1( eval_callback_pinch -> get( ) , args );       	
    }

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_gestures_GesturePan_onPan(
																	JNIEnv * env, 
																	jobject  obj ,
																	jint phase,
																	jfloat fx , 
																	jfloat fy ,
																	jfloat vx , 
																	jfloat vy ,
																	jfloat pressure
    															){
    	
    	value args = alloc_array( 6 );
    	val_array_set_i( args , 0 , alloc_int( phase ) );
    	val_array_set_i( args , 1 , alloc_float( fx ) );
    	val_array_set_i( args , 2 , alloc_float( fy ) );
    	val_array_set_i( args , 3 , alloc_float( vx ) );
    	val_array_set_i( args , 4 , alloc_float( vy ) );
    	val_array_set_i( args , 5 , alloc_float( pressure ) );
    	val_call1( eval_callback_pan -> get( ) , args );       	
    }

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_gestures_GestureRotation_onRot(
																	JNIEnv * env, 
																	jobject  obj ,
																	jint phase,
																	jfloat fx , 
																	jfloat fy ,
																	jfloat deg,
																	jfloat pressure
    															){
    	
    	value args = alloc_array( 5 );
    	val_array_set_i( args , 0 , alloc_int( phase ) );
    	val_array_set_i( args , 1 , alloc_float( fx ) );
    	val_array_set_i( args , 2 , alloc_float( fy ) );
    	val_array_set_i( args , 3 , alloc_float( deg ) );
    	val_array_set_i( args , 4 , alloc_float( pressure ) );
    	val_call1( eval_callback_rot -> get( ) , args );       	
    }

}
#endif