
#ifndef IPHONE
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <hx/Macros.h>
#include <stdio.h>
#include <hxcpp.h>
#include "HyperTouch.h"

#ifdef ANDROID
#include <jni.h>
#endif

using namespace Hyperfiction;

#ifdef ANDROID
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
#endif

AutoGCRoot *eval_callback_tap = 0;
AutoGCRoot *eval_callback_longpress = 0;
AutoGCRoot *eval_callback_swipe = 0;
AutoGCRoot *eval_callback_pinch = 0;

extern "C"{
	
	int hypertouch_register_prims(){
		printf("HyperTouch: register_prims()\n");
		//nme_extensions_main( );
		return 0;
	}
	
  	#ifdef ANDROID

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_GestureTap_onTap(
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

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_GestureLongPress_onLongPress(
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

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_GestureSwipe_onSwipe(
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

    JNIEXPORT void JNICALL Java_fr_hyperfiction_hypertouch_GesturePinch_onPinch(
																	JNIEnv * env, 
																	jobject  obj ,
																	jfloat dx , 
																	jfloat dy ,
																	jfloat scaleX , 
																	jfloat scaleY
    															){
    	
    	value args = alloc_array( 4 );
    	val_array_set_i( args , 0 , alloc_float( dx ) );
    	val_array_set_i( args , 1 , alloc_float( dy ) );
    	val_array_set_i( args , 2 , alloc_float( scaleX ) );
    	val_array_set_i( args , 3 , alloc_float( scaleY ) );
      	val_call1( eval_callback_pinch -> get( ) , args ); 
      	
    }

    #endif
}

// Callbacks ------------------------------------------------------------------------------------------------------------------

	//Taps callback
		static value set_callback_tap( value onCall ){
			printf("Set eval_callback_tap");
			eval_callback_tap = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_tap , 1 );

	//Longpress callback
		static value set_callback_long_press( value onCall ){
			printf("set_callback_long_press");
			eval_callback_longpress = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_long_press , 1 );		

	//Swipe callback
		static value set_callback_swipe( value onCall ){
			printf("set_callback_swipe");
			eval_callback_swipe = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_swipe , 1 );		

	//Pinch callback
		static value set_callback_pinch( value onCall ){
			printf("set_callback_pinch");
			eval_callback_pinch = new AutoGCRoot( onCall );
		    return alloc_bool( true );
		}
		DEFINE_PRIM( set_callback_pinch , 1 );	


		

