//
//  Constants.h
//  LandmarkRemark
//
//  Created by Sasha Reid on 9/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// The purpose of this class is to store and provide global values to reduce magic numbers


#pragma mark - Note Class

// Class Key
extern NSString *const noteClassKey;

// Field Keys
extern NSString *const noteOwnerKey;
extern NSString *const noteOwnerUsernameKey;
extern NSString *const noteTextKey;
extern NSString *const noteLocationKey;




#pragma mark - Enumerations

// Register / Login enumeration. Used to determine what mode the login/register view is on
typedef NS_ENUM(NSInteger, AppEntryMode) {
    AppEntryModeRegister,
    AppEntryModeLogin,
};





@end
