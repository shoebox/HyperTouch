package fr.hyperfiction.hypertouch.enums;

/**
 * ...
 * @author shoe[box]
 */

enum GestureTypes{

	TAP( fingers_count : Int , ?taps_count : Int );
	LONGPRESS;	
	GESTURE_PAN;
	GESTURE_ROTATE;
	GESTURE_SWIPE;
	GESTURE_PINCH;

}