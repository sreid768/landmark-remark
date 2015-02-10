//
//  LoginRegisterViewController.h
//  LandmarkRemark
//
//  Created by Sasha Reid on 10/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginRegisterViewController : UIViewController

// User entry fields
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

// Outlets to the buttons so I can change their name
@property (weak, nonatomic) IBOutlet UIButton *registerButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *switchButtonOutlet;

// Outlet to one of the botton constraints so I can move them when changing modes
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RegisterVerticlePositionConstraint;


// Buttons
- (IBAction)registerButton:(UIButton *)sender;
- (IBAction)switchButton:(UIButton *)sender;





@end
