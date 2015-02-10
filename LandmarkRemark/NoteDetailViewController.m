//
//  NoteDetailViewController.m
//  LandmarkRemark
//
//  Created by Sasha Reid on 9/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "NoteDetailViewController.h"

@interface NoteDetailViewController ()

@end


@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title
    self.title = @"Note Detail";

    // Check to make sure an object was actually passed
    if (self.noteObject != nil) {
        
        // If it was, update the interface with the note's data
        self.noteOwner.text = self.noteObject[noteOwnerUsernameKey];
        
        NSDate * date = self.noteObject.createdAt;
        self.noteDate.text = [self formatDateForDisplay:date];
        
        self.noteText.text = self.noteObject[noteTextKey];
        self.noteText.font = [UIFont systemFontOfSize:25];
        self.noteText.textAlignment = NSTextAlignmentCenter;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSString *) formatDateForDisplay: (NSDate *) date {
    
    // This method is just to help format the date correctly. The Parse date is very messy.

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [formatter setLocale:posix];
    [formatter setDateFormat:@"EEE, MMM dd yyyy"]; //Tue, Feb 10 2015
    
    NSString * formattedDate = [formatter stringFromDate:date];
    
    return formattedDate;
}




@end
