//
//  NoteDetailViewController.h
//  LandmarkRemark
//
//  Created by Sasha Reid on 9/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "MapViewController.h"

@interface NoteDetailViewController : MapViewController

// A PFObject is passed prior to loading this controller
@property (nonatomic, strong) PFObject * noteObject;

// Outlets to objects needed in the implementation
@property (weak, nonatomic) IBOutlet UILabel *noteOwner;
@property (weak, nonatomic) IBOutlet UILabel *noteDate;
@property (weak, nonatomic) IBOutlet UITextView *noteText;



@end
