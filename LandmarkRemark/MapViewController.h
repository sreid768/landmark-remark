//
//  ViewController.h
//  LandmarkRemark
//
//  Created by Sasha Reid on 9/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

// Outlets to objects needed in the implementation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButtonOutlet;


// Buttons
- (IBAction)addNoteButton:(UIBarButtonItem *)sender;



@end

