#ifndef Device
#define Device

namespace Hyperfiction{

	void init_hyp_touch( );

	bool activateGesture( int gestureCode , int iFingers );
	bool deactivateGesture( int gestureCode );
	
	void onTap( int iFingers , int iTaps , int iPhase , float fx , float fy );
	void onSwipe( int iFingers , int iDir , float fVx , float fVy , float fDx , float fDy );
	void onLongPress( int iFingers , int iTaps , int iPhase , float fx , float fy );
	void onPinch( int iPhase , float dx , float dy ,float fScale );
	void onPan( int iPhase , float dx , float dy , float vx , float vy );
	void onRot( int phase , float fx , float fy , float deg );	
}

#endif