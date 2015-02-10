//
//  CustomPointAnnotation.h
//  LandmarkRemark
//
//  Created by Sasha Reid on 9/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomPointAnnotation : MKPointAnnotation

// Adding a reference to the PFObject to assist with colouring map pins 
@property (nonatomic, strong) PFObject * noteObject;

@end
