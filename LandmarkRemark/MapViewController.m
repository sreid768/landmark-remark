//
//  ViewController.m
//  LandmarkRemark
//
//  Created by Sasha Reid on 9/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "MapViewController.h"
#import "CustomPointAnnotation.h"
#import "NoteDetailViewController.h"


@interface MapViewController () {
    NSMutableArray * allNotes; // Stores notes shown on the map
    PFObject * selectedNote; // Temporary storage of selected note to assist with prepareForSegue
}

@property (nonatomic, strong) UISearchController *searchController;

@end



@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title
    self.title = @"Landmark Remark";

    // Initialise the variables
    allNotes = [NSMutableArray array];
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Assign self to the delegates
    self.locationManager.delegate = self;
    self.mapViewOutlet.delegate = self;
    
    // Kick off downloading notes from Parse
    [self downloadNotesFromParse];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSString *) truncateString:(NSString *) string {
    
    // This method will cut the length of a note when showing on the map
    // It's purely designed to make the map cleaner
    
    const int maxLength = 30;
    
    if (string.length > maxLength) {
        return [[string substringToIndex:maxLength] stringByAppendingString:@"..."];
    }
    else {
        return string;
    }
}




- (void) downloadNotesFromParse {
    
    // This method creates a query to download all notes from Parse
    // Ideally I would constrain by user's location but not given the limited number of notes
    
    PFQuery * noteQuery = [PFQuery queryWithClassName:noteClassKey];
    
    [noteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        // Update the local variable storing all notes
        allNotes = (NSMutableArray *) objects;
        
        // Run a method to update the map with the new notes
        [self updateMapWithNotes];
    }];
}



- (void) updateMapWithNotes {
    
    // This method updates the map will all notes in the local array
    
    // Remove any existing annotations
    [self.mapViewOutlet removeAnnotations:self.mapViewOutlet.annotations];
    
    // Add the notes found on Parse to the map using annotations
    for (PFObject * currentNote in allNotes) {
        
        // Grab the data I'll be using to populate the annotation with
        NSString * noteUsername = currentNote[noteOwnerUsernameKey];
        NSString * noteText = currentNote[noteTextKey];
        PFGeoPoint * noteLocation = currentNote[noteLocationKey];
        
        //Create a new custom annotation (custom as it stores a PFObject)
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        
        //Update the annotation with the data
        annotation.title = [self truncateString:noteText];
        annotation.subtitle = noteUsername;
        annotation.noteObject = currentNote;
        [annotation setCoordinate:CLLocationCoordinate2DMake(noteLocation.latitude, noteLocation.longitude)];

        //Add the annotation to the map
        [self.mapViewOutlet addAnnotation:annotation];
    }
}





- (void) uploadNewNoteToParse:(NSString *) noteText {
    
    // This method uploads a new note to Parse given the note text

    PFObject * newNote = [PFObject objectWithClassName:noteClassKey];
    
    // Add the required attributes to the PFObject
    newNote[noteOwnerKey] = [PFUser currentUser];
    newNote[noteOwnerUsernameKey] = [PFUser currentUser].username;
    newNote[noteTextKey] = noteText;
    newNote[noteLocationKey] = [PFGeoPoint geoPointWithLatitude:
                                self.locationManager.location.coordinate.latitude longitude:
                                self.locationManager.location.coordinate.longitude];
    
    // Save the note to Parse
    [newNote saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"Note successfully uploaded to Parse");
        
        // Once the note has been successfully uploaded, get a new snapshot of all notes
        // This will show the new note and update the map with any other user notes
        [self downloadNotesFromParse];
    }];
}








#pragma mark - Location Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // This is new in iOS8. It will request location access on first or kick start the user location
    // Additionally, this method will run again after the user has granted permission
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        // I DO have authorisation. Start updating the user location and show it on the map
        [self.locationManager startUpdatingLocation];
        self.mapViewOutlet.showsUserLocation = YES;
        [self.mapViewOutlet setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        // Enable the add button as we have location permission
        self.addButtonOutlet.enabled = YES;
    }
    else if (status == kCLAuthorizationStatusNotDetermined) {
        
        // I don't have the user authentication yet. Request it
        [self.locationManager requestWhenInUseAuthorization];
        
        // Disable the add button in the meantime
        self.addButtonOutlet.enabled = NO;
    }
    else {
        
        // I can't do much if they've disabled user location.
        // Just display an error and disable adding a note button
        
        NSLog(@"Maps authorisation hasn't been granted.");

        // Disable the add button until authorisation is granted
        self.addButtonOutlet.enabled = NO;

        // Show an alert to the user
        NSString * alertTitle = @"Authorisation Required";
        NSString * alertMessage = @"We can't determine your location which is needed to add notes. You can activate this again in settings.";
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:alertTitle
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}







#pragma mark - Map View Delegate Methods


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Add any custom annotations.
    if ([annotation isKindOfClass:[CustomPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            
            // All pins will show a callout showing a summary when clicked
            [pinView setCanShowCallout:YES];
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
        } else {
            // An existing pin was available. Use that
            pinView.annotation = annotation;
        }
        
        // Create a custom annotation to show note and store PFObject
        CustomPointAnnotation * customAnnotation = (CustomPointAnnotation *) annotation;
        NSString * noteOwnerUsername = customAnnotation.noteObject[noteOwnerUsernameKey];
        NSString * currentUserUsername = [PFUser currentUser].username;
        
        if ([currentUserUsername isEqualToString:noteOwnerUsername]) {
            // Any pins created by the current user will be RED and animate
            [pinView setPinColor:MKPinAnnotationColorRed];
            [pinView setAnimatesDrop:YES];
        }
        else {
            // Any pins NOT created by the current user will be GREEN and not animate
            [pinView setPinColor:MKPinAnnotationColorGreen];
            [pinView setAnimatesDrop:NO];
        }
        
        return pinView;
    }
    return nil;
}




- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    // Grabs the selected pin and stores the corresponding PFObject for the PrepareForSegue method
    CustomPointAnnotation * annotation = (CustomPointAnnotation *)view.annotation;
    selectedNote = annotation.noteObject;
    
    // Segue to the NoteDetailViewController to show the detail of the note
    [self performSegueWithIdentifier:@"noteDetailSegue" sender:self];
}









#pragma mark - Buttons


- (IBAction)addNoteButton:(UIBarButtonItem *)sender {
    
    // This button will show an alert box and allow the user to specify a new note.
    // Any new notes will be uploaded to Parse and shown on the map
    
    NSString * alertTitle = @"New Note";
    NSString * alertMessage = @"Enter a note in the text box below to have to appear on the map. All notes are visible to users of the app.";
    NSString * alertPlaceholderText = @"your fancy note";
    
    // Create the alert
    UIAlertController * alert= [UIAlertController
                                  alertControllerWithTitle:alertTitle
                                  message:alertMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // The alert needs a text box which is configured below.
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = alertPlaceholderText;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeYes;
        textField.spellCheckingType = UITextSpellCheckingTypeYes;
    }];
    
    // The alert will use an OK method which dismisses the alert box and uploads the new note
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   UITextField *textField = alert.textFields.firstObject;
                                                   [self uploadNewNoteToParse:textField.text];
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    // The alert will also use a Cancel method which dismisses the alert box only
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    // Adding the buttons to the alert box
    [alert addAction:cancel];
    [alert addAction:ok];

    // Present the alert
    [self presentViewController:alert animated:YES completion:nil];
}









#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // I need to pass the PFObject to the noteDetailViewController to display.
    // Use the local variable which was updated when the annotation callout was tapped
    
    if ([segue.identifier isEqualToString:@"noteDetailSegue"]) {
        
        // Make sure it's the correct Segue. Then grab the new ViewController and pass the object
        NoteDetailViewController * destination = (NoteDetailViewController *) segue.destinationViewController;
        destination.noteObject = selectedNote;
    }
}
 






@end
