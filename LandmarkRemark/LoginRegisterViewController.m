//
//  LoginRegisterViewController.m
//  LandmarkRemark
//
//  Created by Sasha Reid on 10/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "LoginRegisterViewController.h"

@interface LoginRegisterViewController () {
    AppEntryMode currentAppMode; // Keeps track of the current mode (Login or Registration)
}

@end

@implementation LoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup the interface for the first time
    [self firstSetupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) firstSetupInterface {
    
    // This makes sure the interface is configured for Login
    // This isn't done in the storyboard as I need to show all fields there
    self.emailTextField.hidden = YES;
    self.emailTextField.alpha = 1.0;
    self.RegisterVerticlePositionConstraint.constant -= self.emailTextField.frame.size.height;
    [self.registerButtonOutlet setTitle:@"Login" forState:UIControlStateNormal];
    [self.switchButtonOutlet setTitle:@"New to the app? Click here." forState:UIControlStateNormal];
    [self.view layoutIfNeeded];
    
    // Set the default entry mode. This is designed to show the login forms first
    currentAppMode = AppEntryModeLogin;
}



- (void) showErrorMessage: (NSNumber *) errorCode {
    
    // This is a helper method to show an alert box with any errors from Login or Registration
    
    NSString * alertTitle = @"Login / Registration Error";
    NSString * alertMessage = @"";
    
    // Go through the Parse error codes and display the most appropriate error message to the user
    switch(errorCode.intValue)
    {
        case 101: // Invalid login credentials
            alertMessage = @"Please check your username / password combination and try again.";
            break;
        case 125: // Invalid email address credentials
            alertMessage = @"The email address supplied is invalid. Please check your email and try again.";
            break;
        case 200: // Username is blank
            alertMessage = @"The username field is empty. Please add a username and try again.";
            break;
        case 201: // Password is blank
            alertMessage = @"The password field is empty. Please add a password and try again.";
            break;
        case 202: // Username is already taken
            alertMessage = @"That username is already taken. Try something else.";
            break;
        case 203: // Email is already taken
            alertMessage = @"That email is already taken. Try something else.";
            break;
        case 204: // Email is blank
            alertMessage = @"The email field is empty. Please add an email address and try again.";
            break;
        case 205: // Username / Email account is invalid.
            alertMessage = @"The username or email address supplied is invalid. Please check these fields and try again.";
            break;
        default: // Catch something abnormal
            alertMessage = @"An error occured. Please contact customer support of 0403 435 545.";
            break;
    }
    
    // Create the alert box. Since we're doing iOS8 only I'm using UIAlertController
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    // Add the OK button
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }];
    [alertController addAction:okAction];
    
    // Show the alert
    [self presentViewController:alertController animated:YES completion:nil];
    
}







#pragma mark - Buttons



- (IBAction)registerButton:(UIButton *)sender {
    
    // This button will EITHER submit a new user registration or do a login.
    // We need to test what mode the interface is in and perform the correct instruction.
    
    if (currentAppMode == AppEntryModeLogin) {
        
        // The app is currently showing the login fields. Login using the supplied details
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text
                                     password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
            if (user) {
                // Login successful. Segue to the MapViewController
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
            else {
                // The login failed. Show an error message using the error code
                [self showErrorMessage:[error userInfo][@"code"]];
            }
        }];
    }
    else if (currentAppMode == AppEntryModeRegister) {
        
        // The app is currently showing the Register fields. Regster using the supplied details
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        
        // Run the sign up method and test for errors
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Registration successful. Segue to the MapViewController
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
            else {
                // Registration failed. Show an error message using the error code
                [self showErrorMessage:[error userInfo][@"code"]];
            }
        }];
    }
}




- (IBAction)switchButton:(UIButton *)sender {
    
    //This button switches the mode from Login to Register and visa-versa
    
    if (currentAppMode == AppEntryModeLogin) {
        
        // Changing mode FROM login TO registration
        // I need to show the registration fields and adjust the interface accordingly.
        // I'm doing this in an animation to make the experience nicer
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.emailTextField.alpha = 1.0;
                             self.RegisterVerticlePositionConstraint.constant += self.emailTextField.frame.size.height;
                             [self.registerButtonOutlet setTitle:@"Register" forState:UIControlStateNormal];
                             [self.switchButtonOutlet setTitle:@"already have an account? Click here." forState:UIControlStateNormal];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             self.emailTextField.hidden = NO;
                             
                         }];
        currentAppMode = AppEntryModeRegister;
    }
    else if (currentAppMode == AppEntryModeRegister) {
        
        // Changing mode FROM registration TO login
        // I need to show the login fields and adjust the interface accordingly.
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.emailTextField.alpha = 0.0;
                             self.RegisterVerticlePositionConstraint.constant -= self.emailTextField.frame.size.height;
                             [self.registerButtonOutlet setTitle:@"Login" forState:UIControlStateNormal];
                             [self.switchButtonOutlet setTitle:@"New to the app? Click now." forState:UIControlStateNormal];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             self.emailTextField.hidden = YES;
                             
                         }];
        currentAppMode = AppEntryModeLogin;
    }
}









@end
