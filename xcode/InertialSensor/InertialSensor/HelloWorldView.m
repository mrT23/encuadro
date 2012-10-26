//
//  HelloWorldView.m
//  InertialSensor
//
//  Created by Juan Ignacio Braun on 8/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"

@implementation HelloWorldView

- (id) init {
	
	if ((self = [super init])) {

        CMAttitude *referenceAttitude;
        if (motionManager == nil) {
            motionManager = [[CMMotionManager alloc] init];
        }
        motionManager.accelerometerUpdateInterval = 0.01;
        motionManager.deviceMotionUpdateInterval = 0.01;
        [motionManager startDeviceMotionUpdates];
        dm = motionManager.deviceMotion;
        referenceAttitude = [dm.attitude retain];
        
        // Translate the camera.
		[self.camera setPosition:iv3(0, 3, 7)];

		// Create texture material with text
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithText:@"Hello World!" fontName:@"Arial" fontSize:48];
	
		// Create a UV Map so that only the rendered content of the texture is shown on plane
		float uMax = material.contentSize.width / material.width;
		float vMax = material.contentSize.height / material.height;
		Isgl3dUVMap * uvMap = [Isgl3dUVMap uvMapWithUA:0 vA:0 uB:uMax vB:0 uC:0 vC:vMax];
		
		// Create a plane with corresponding UV map
		Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometryAndUVMap:6 height:2 nx:2 ny:2 uvMap:uvMap];
		
		// Create node to render the material on the plane (double sided to see back of plane)
		_3dText = [self.scene createNodeWithMesh:plane andMaterial:material];
		_3dText.doubleSided = YES;
		
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) tick:(float)dt {
    
    CMRotationMatrix rotation;
    CMAcceleration userAcceleration;
    dm = motionManager.deviceMotion;
    CMAttitude *attitude = dm.attitude;
    rotation = attitude.rotationMatrix;
    [motionManager startDeviceMotionUpdates];
    _3dText.rotationX=-attitude.roll*180/M_PI;
    _3dText.rotationY=attitude.yaw*180/M_PI;
	_3dText.rotationZ=-attitude.pitch*180/M_PI;
    NSLog(@"X%f",_3dText.rotationX);
    NSLog(@"Y%f",_3dText.rotationY);
    NSLog(@"Z%f",_3dText.rotationZ);
//    NSLog(@"%f",_3dText.rotationZ);
    
}




@end
